package ifrs.edu.br.venda;


import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;
import ifrs.edu.br.negocio.Cliente;
import org.postgresql.ds.PGConnectionPoolDataSource;

import java.math.RoundingMode;
import java.sql.*;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.LinkedList;
import java.util.Scanner;

public class Venda implements OperacoesCrud {
    private Cliente cliente;
    private float valorTotal;
    private Date date;
    private boolean status;
    private LinkedList<ItemVenda> listaItens = new LinkedList<>();

    public Venda(Cliente cliente, Date date){
        this.cliente = cliente;
        this.date = date;
        this.status = true;
    }

    public Venda(){
    }

    public void cancelarVenda(){
        this.status = false;
    }

    public boolean adicionarItem(ItemVenda item){
        try {
            if(!this.listaItens.contains(item)) {
                this.listaItens.add(item);
                float total = 0;
                for (ItemVenda listaIten : listaItens) {
                    total += listaIten.getValorUnitario()*listaIten.getQuantidade();
                }
                this.valorTotal = total;
            }
            else {
                System.out.println("Opa valor ja presente.");
            }
        }
        catch (Exception e){
            return false;
        }
        return true;
    }

    public boolean removerItem(ItemVenda item){
        try {
            this.listaItens.remove(item);
            float total = 0;
            for (ItemVenda listaIten : listaItens) {
                total -= listaIten.getValorUnitario()*listaIten.getQuantidade();
            }
            this.valorTotal = total;
        }
        catch (Exception e) {
            return false;
        }
        return true;
    }

    private void menuItens(){
        System.out.println("\nSelecione uma acao");
        System.out.println("0) Adicionar");
        System.out.println("1) Remover");
        System.out.println("2) Finalizar compra");
        System.out.print("Op: ");
    }

    private void menuAlteraItens(){
        System.out.println("\nSelecione uma acao");
        System.out.println("0) Editar");
        System.out.println("1) Adicionar");
        System.out.println("2) Remover");
        System.out.println("3) Finalizar alteracoes");
        System.out.print("Op: ");
    }

    @Override
    public String toString(){
        DecimalFormat df = new DecimalFormat("#.##");
        return String.format("valor total: %s | status: %b", df.format(this.valorTotal), this.status);
    }

    @Override
    public ResultObjectTuple cadastrar(PGConnectionPoolDataSource dataSource) throws SQLException {
        Connection pgConnection = conectar(dataSource).getConnection();
        ResultSet resultSet = null;
        try {
            this.status = true;
            this.date = java.sql.Date.valueOf(LocalDate.now());
            Statement statement = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            Cliente cli = new Cliente();
            ResultSet rs = cli.procuraRegistro(pgConnection);
            int rowInicial = rs.getRow();
            rs.last();
            if(rowInicial == rs.getRow()){
                System.out.println("Nenhum registro encontrado");
                return new ResultObjectTuple();
            }
            else {
                rs.first();
            }
            rs = selecionaRow(rs, cli);
            this.cliente = new Cliente(rs);
            boolean continuarAdicionarItens = true;

            Statement venda = pgConnection.createStatement();
            venda.execute("INSERT INTO venda (venda_cliente, data, valor_total, status)" +
                    " VALUES ('"+String.valueOf(rs.getInt("id"))+"','"+
                    this.date+"','"+this.valorTotal+"','true') RETURNING *;");
            resultSet = venda.getResultSet(); //Pegando o retorno da insersao para uso nos itens
            resultSet.next();
            pgConnection.commit();
            int venda_id = resultSet.getInt("id");

            while (continuarAdicionarItens){
                menuItens();
                Scanner sc = new Scanner(System.in);
                int operacao = sc.nextInt();
                if(operacao == 2){
                    continuarAdicionarItens = false;
                    if(this.valorTotal <= 0){
                        pgConnection.rollback();
                    }
                }
                else {
                    if(operacao == 0) {
                        ItemVenda item = new ItemVenda();
                        item.setVendaId(venda_id);
                        ResultObjectTuple result = item.cadastrar(dataSource);
                        if (result.getResultSet() != null) {
                            item = (ItemVenda) result.getObject();
                        } else {
                            continue;
                        }
                        if (!listaItens.contains(item)) {
                            adicionarItem(item);
                        }
                    }
                    else {
                        ItemVenda item = new ItemVenda();
                        item.setVendaId(venda_id);
                        item.operacoesListaDeVenda(venda_id,dataSource,"2");
                        removerItem(item);
                    }
                }
            }
            pgConnection.commit();
            resultSet.close();
        }
        catch (Exception e){
            pgConnection.rollback();
            System.err.println(e);
        }
        return new ResultObjectTuple(resultSet, this);
        //cliente = pesquisarCliente();
        //data = Date;
        //status = true;
        //listaItens = addListaItems(); //Laco adicionando produtos na lista e banco
        //valorTotal = total dos valores dos produtos
    }

    @Override
    public void editar(PGConnectionPoolDataSource dataSource) throws SQLException {
        Connection pgConnection = conectar(dataSource).getConnection();
        ResultSet rs = procuraRegistro(pgConnection);
        if(rs == null){
            return;
        }
        int rowInicial = rs.getRow();
        rs.last();
        if(rowInicial == rs.getRow()){
            return;
        }
        else {
            rs.first();
        }
        rs = selecionaRow(rs, this);
        if(rs == null){
            return;
        }
        ItemVenda itens = new ItemVenda();
        Scanner sc = new Scanner(System.in);
        while (true) {
            menuAlteraItens();
            String op = sc.nextLine();
            if(!op.contains("3")) {
                itens.operacoesListaDeVenda(rs.getInt("id"), dataSource, op);
            }
            else {
                break;
            }
        }
        //this = pesquisa compra;
        //lista os items
        //pede para remover itens ou alterar quantidade
        //re-calcula o preco final
        //atualiza no banco

    }

    @Override
    public void deletar(PGConnectionPoolDataSource dataSource) throws SQLException {
        Connection pgConnection = conectar(dataSource).getConnection();
        ResultSet rs = procuraRegistro(pgConnection);
        rs = selecionaRow(rs, this);
        rs.updateBoolean("status", false);
        rs.updateRow();
        pgConnection.commit();
        rs.close();
        pgConnection.close();
        //cancelar venda
        //atualiza no banco
    }

    @Override
    public ResultSet procuraRegistro(Connection connection) throws SQLException {
        System.out.println("Digite o nome ou cpf do cliente");
        Scanner sc = new Scanner(System.in);
        String entrada = sc.nextLine();
        Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = null;
        rs = pesquisa(0, entrada, stmt);
        return rs;
    }

    @Override
    public ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException {
        String query = "SELECT * FROM venda INNER JOIN pessoa ON (venda.venda_cliente = pessoa.id)";
        if(tipo != 3) {
            try{
                int test = Integer.parseInt(entrada);
                query+=" WHERE cpf = '" + entrada+"';";
            }
            catch (NumberFormatException e){
                query+="WHERE nome LIKE '" + entrada + "%';";
            }
        }
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

    @Override
    public Integer construirMenu(ResultSet rs, Integer base) throws SQLException {
        System.out.println("Resultados de pesquisa");
        base+=1;
        int n=0;
        for (n=base;n<=base+9;n++){
            rs.absolute(n);
            DecimalFormat df = new DecimalFormat("0.00");
            df.setRoundingMode(RoundingMode.CEILING);
            String total = df.format(rs.getFloat("valor_total"));
            System.out.println(String.format("%d) %s - %s - %s %s", n, rs.getString("nome"),
                    total, String.valueOf(rs.getDate("data")), isAtivo(rs.getBoolean("status"))));

            if(!rs.absolute(n+1)){
                break;
            }
        }
        rs.last();
        int limite = rs.getRow();
        if(base < limite && limite-base > 9){
            System.out.println(".) Proximo");
        }
        if(base > 10){
            System.out.println(",) Anterior");
        }
        System.out.println("q) Voltar");

        return n;
    }

    private String isAtivo(Boolean bool){
        if(bool){
            return "Ativo";
        }
        else {
            return "Cancelada";
        }
    }

}
