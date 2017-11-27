package ifrs.edu.br.venda;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;
import ifrs.edu.br.negocio.Produto;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.math.RoundingMode;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.Scanner;

public class ItemVenda implements OperacoesCrud {
    private Produto produto;
    private float quantidade;
    private float valorUnitario;
    private int[] ids;
    private ResultSet itensAssociadosAVenda;
    private Connection connection;

    private void setIdsBanco(int[] ids){
        this.ids = ids;
    }

    public int[] getIdsBanco(){
        return this.ids;
    }

    public int getProduto(Connection connection) throws SQLException {
        ResultSet rs = connection.createStatement().executeQuery("SELECT * FROM produto" +
                " WHERE nome = '"+this.produto.getNome()+"'");
        rs.next();
        return rs.getInt("id");
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public float getQuantidade() {
        return quantidade;
    }

    void setQuantidade(float quantidade) {
        this.quantidade = quantidade;
    }

    float getValorUnitario() {
        return valorUnitario;
    }

    public void setValorUnitario(float valorUnitario) {
        this.valorUnitario = valorUnitario;
    }

    public void operacoesListaDeVenda(Integer vendaId, PGConnectionPoolDataSource dataSource, Boolean op) throws SQLException{
        try(ResultSet rs = pesquisa(0,String.valueOf(vendaId),conectar(dataSource).getConnection().createStatement(
                ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE))){
            this.itensAssociadosAVenda = rs;
            this.connection = conectar(dataSource).getConnection();
            if(op) {
                editar(dataSource);
            }
            else {
                deletar(dataSource);
            }
        }
    }

    private void entradaUsuario(boolean todasAsEntradas, Connection connection) throws SQLException{
        Scanner sc = new Scanner(System.in);
        if(!todasAsEntradas){
            System.out.println("Deseja alterar o produto N/s");
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                setProduto(connection);
            }
        }
        else {
            setProduto(connection);
        }
        System.out.print("Digite a quantidade: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.quantidade = Integer.parseInt(tmp);
            }
        }
        else {
            this.quantidade = sc.nextInt();
        }
    }

    private void setProduto(Connection connection) throws SQLException{
        Produto prod = new Produto();
        ResultSet rs = prod.procuraRegistro(connection);
        rs = prod.selecionaRow(rs, prod);
        this.produto = new Produto(rs);
        this.setValorUnitario(rs.getFloat("preco"));
        rs.close();
    }

    @Override
    public boolean equals(Object object){
        ItemVenda itemVenda = (ItemVenda) object;
        return itemVenda.produto.equals(this.produto);
    }

    @Override
    public ResultObjectTuple cadastrar(PGConnectionPoolDataSource dataSource) throws SQLException {
        Connection pgConnection = conectar(dataSource).getConnection();
        Statement statement = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
            ResultSet.CONCUR_UPDATABLE);
        entradaUsuario(true, pgConnection);
        statement.execute("INSERT INTO item_venda (fk_item_produto, preco, quantidade)" +
                "VALUES ('"+this.getProduto(pgConnection)+"','"+this.valorUnitario+"'," +
                "'"+this.quantidade+"') RETURNING *");
        //escolhe um produto
        //popula o valorUnitario com o valor do produto (nao he referencia)
        //pede quantidade
        //cadastra no banco
        pgConnection.commit();
        ResultSet rs = statement.getResultSet();
        rs.next();
        int[] ids = {rs.getInt("id"), this.getProduto(pgConnection)};
        this.ids = ids;
        return new ResultObjectTuple(rs, this);
    }

    private Produto transformaEmProduto(ResultSet rs) throws SQLException{
        Produto produto = new Produto(rs);
        return produto;
    }

    @Override
    public void editar(PGConnectionPoolDataSource dataSource) throws SQLException {
        ResultSet rs = null;
        Connection pgConnection = conectar(dataSource).getConnection();
        if(this.itensAssociadosAVenda == null){
            return;
        }
        int rowInicial = this.itensAssociadosAVenda.getRow();
        this.itensAssociadosAVenda.last();
        if(rowInicial == this.itensAssociadosAVenda.getRow()){
            return;
        }
        else {
            this.itensAssociadosAVenda.first();
        }
        rs = selecionaRow(this.itensAssociadosAVenda, this);
        if(rs == null){
            return;
        }
        Statement statement = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet resultSet = statement.executeQuery("SELECT * FROM item_venda WHERE id = '"
                +rs.getInt("lista_item_id")+"'" +
                " AND fk_item_produto = '"+rs.getInt("lista_item_prod")+"';");
        //pgConnection.commit();
        Statement statementProd = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet resultSetProduto = statementProd.executeQuery("SELECT * FROM produto WHERE id = '"+
                rs.getInt("lista_item_prod")+"'");
        resultSetProduto.first();
        resultSet.first();
        this.produto = transformaEmProduto(resultSetProduto);
        this.quantidade = resultSet.getFloat("quantidade");
        this.valorUnitario = resultSet.getFloat("preco");
        int item_id = resultSet.getInt("id");

        entradaUsuario(false, pgConnection);

        PreparedStatement pStatementItem = pgConnection.prepareStatement("UPDATE item_venda SET fk_item_produto = ?," +
                " preco = ?, quantidade = ? WHERE id = ?");
        PreparedStatement pStatementItemAssoc = pgConnection.prepareStatement("UPDATE lista_venda set lista_item_id = ?," +
                " lista_item_prod = ?, venda_item = ? WHERE id = ?");

        //PreparedStatement pStatementItemELista = pgConnection.prepareStatement("UPDATE item_venda SET fk_item_produto = ? JOIN lista venda" +
        //  "ON item_venda.id = lista_item_id SET lista_item_prod = ?, preco = ?, quantidade = ?");

        pStatementItem.setInt(1, this.getProduto(pgConnection));
        pStatementItem.setFloat(2, this.valorUnitario);
        pStatementItem.setFloat(3, this.quantidade);
        pStatementItem.setInt(4, item_id);

        pStatementItemAssoc.setInt(1, item_id);
        pStatementItemAssoc.setInt(2, this.getProduto(pgConnection));
        pStatementItemAssoc.setInt(3, rs.getInt("venda_item"));
        pStatementItemAssoc.setInt(4, rs.getInt("id"));

        pStatementItemAssoc.execute();
        pStatementItem.execute();

        Statement statementTotal = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet totalValor = statementTotal.executeQuery("SELECT SUM(preco*quantidade) AS total FROM item_venda CROSS JOIN lista_venda" +
                " WHERE item_venda.id = lista_venda.lista_item_id AND venda_item = '"+rs.getInt("venda_item")+"';");
        totalValor.first();
        PreparedStatement pStatementVenda = pgConnection.prepareStatement("UPDATE venda" +
                " SET valor_total = ? WHERE id = ?");
        pStatementVenda.setFloat(1, totalValor.getFloat("total"));
        pStatementVenda.setInt(2, rs.getInt("venda_item"));
        pStatementVenda.execute();

        statement.close();
        pStatementItem.close();
        pStatementItemAssoc.close();
        pStatementVenda.close();

        pgConnection.commit();
        rs.close();
        pgConnection.close();
        //le tabela relacao buscando pela venda e produto
        //atualiza quantidade e recalcula total na venda
    }

    @Override
    public void deletar(PGConnectionPoolDataSource dataSource) throws SQLException{
        ResultSet rs = null;
        Connection pgConnection = conectar(dataSource).getConnection();
        if(this.itensAssociadosAVenda == null){
            return;
        }
        int rowInicial = this.itensAssociadosAVenda.getRow();
        this.itensAssociadosAVenda.last();
        if(rowInicial == this.itensAssociadosAVenda.getRow()){
            return;
        }
        else {
            this.itensAssociadosAVenda.first();
        }
        rs = selecionaRow(this.itensAssociadosAVenda, this);
        if(rs == null){
            return;
        }
        PreparedStatement pStatement = pgConnection.prepareStatement("DELETE FROM item_venda WHERE id = ?");
        PreparedStatement pStatementLista = pgConnection.prepareStatement("DELETE FROM lista_venda WHERE " +
                "lista_item_id = ?");
        pStatement.setInt(1, rs.getInt("lista_item_id"));
        pStatementLista.setInt(1, rs.getInt("lista_item_id"));

        pStatement.execute();
        pStatementLista.execute();
        pgConnection.commit();

        Statement statement = pgConnection.createStatement();
        ResultSet totalValor = statement.executeQuery("SELECT SUM(preco) AS total FROM item_venda CROSS JOIN lista_venda" +
                " WHERE item.venda = lista_venda.lista_item_id AND venda_item = '"+rs.getInt("venda_item")+"';");
        PreparedStatement pStatementVenda = pgConnection.prepareStatement("UPDATE venda" +
                " SET valor_total = ? WHERE id = ?");
        pStatementVenda.setFloat(1, totalValor.getFloat("total"));
        pStatementVenda.setInt(2, rs.getInt("venda_item"));
        pStatementVenda.execute();

        pgConnection.commit();
        pStatement.close();
        pStatementLista.close();
        pStatementVenda.close();
        rs.close();
        totalValor.close();
        pgConnection.close();

        //remove linha da tabela relacao
        //recalcula total da venda
    }

    @Override
    public ResultSet procuraRegistro(Connection connection) throws SQLException {
        throw new UnsupportedOperationException();
    }

    @Override
    public ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException {
        String[] entradaTratada = entrada.split(";");
        String query = "SELECT * FROM lista_venda ";
        if(tipo != 3) {
            query+="WHERE venda_item = '" + entradaTratada[0] + "';";
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
            Statement statement = this.connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            ResultSet produto = statement.executeQuery("SELECT * FROM produto WHERE id = '"
                    +this.itensAssociadosAVenda.getInt("lista_item_prod")+"'");
            DecimalFormat df = new DecimalFormat("0.00");
            df.setRoundingMode(RoundingMode.CEILING);
            produto.first();
            String preco = df.format(produto.getFloat("preco"));
            System.out.println(String.format("%d) %s - %s", n, produto.getString("nome"),
                    preco));
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

}
