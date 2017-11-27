package ifrs.edu.br.venda;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;
import ifrs.edu.br.negocio.Produto;
import org.postgresql.ds.PGConnectionPoolDataSource;

import java.math.RoundingMode;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.Scanner;

public class ItemVenda implements OperacoesCrud {
    private Produto produto;
    private float quantidade;
    private float valorUnitario;
    private int[] ids;
    private int vendaId;
    private ResultSet itensAssociadosAVenda;
    private Connection connection;

    private void setIdsBanco(int[] ids){
        this.ids = ids;
    }

    public int[] getIdsBanco(){
        return this.ids;
    }

    public void setVendaId(int vendaId) {
        this.vendaId = vendaId;
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

    public void operacoesListaDeVenda(Integer vendaId, PGConnectionPoolDataSource dataSource, String op) throws SQLException{
        try(ResultSet rs = pesquisa(0,String.valueOf(vendaId),conectar(dataSource).getConnection().createStatement(
                ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE))){
            this.vendaId =vendaId;
            this.itensAssociadosAVenda = rs;
            this.connection = conectar(dataSource).getConnection();
            if(op.contains("0")) {
                editar(dataSource);
            }
            else {
                if(op.contains("1")){
                    cadastrar(dataSource);
                }
                else {
                    deletar(dataSource);
                }
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
        if(this.produto == null){
            this.produto = new Produto();
        }
        if(!this.produto.equals(new Produto(rs))){
            this.produto = new Produto(rs);
            this.setValorUnitario(rs.getFloat("preco"));
        }
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
        ResultSet rs = null;
        entradaUsuario(true, pgConnection);
        Scanner sc = new Scanner(System.in);
        System.out.println("Deseja confirmar produto? S/n");
        if(!sc.nextLine().contains("n")) {
            statement.execute("INSERT INTO item_venda (fk_item_produto, preco, quantidade, fk_item_venda)" +
                    "VALUES ('" + this.getProduto(pgConnection) + "','" + this.valorUnitario + "'," +
                    "'" + this.quantidade + "', '" + this.vendaId + "') RETURNING *");
            //escolhe um produto
            //popula o valorUnitario com o valor do produto (nao he referencia)
            //pede quantidade
            //cadastra no banco
            pgConnection.commit();
            rs = statement.getResultSet();
            rs.next();
            int[] ids = {rs.getInt("id"), this.getProduto(pgConnection)};
            this.ids = ids;

            Statement statementTotal = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            ResultSet totalValor = statementTotal.executeQuery("SELECT SUM(preco*quantidade) AS total FROM item_venda" +
                    " WHERE fk_item_venda = '"+this.vendaId +"';");
            totalValor.first();
            PreparedStatement pStatementVenda = pgConnection.prepareStatement("UPDATE venda" +
                    " SET valor_total = ? WHERE id = ?");
            pStatementVenda.setFloat(1, totalValor.getFloat("total"));
            pStatementVenda.setInt(2, this.vendaId);
            pStatementVenda.execute();

            pgConnection.commit();
            pStatementVenda.close();
        }
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
        Statement statementProd = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet resultSetProduto = statementProd.executeQuery("SELECT * FROM produto WHERE id = '"+
                rs.getInt("fk_item_produto")+"'");
        resultSetProduto.first();
        this.produto = transformaEmProduto(resultSetProduto);
        this.quantidade = rs.getFloat("quantidade");
        this.valorUnitario = rs.getFloat("preco");
        int item_id = rs.getInt("id");

        entradaUsuario(false, pgConnection);

        PreparedStatement pStatementItem = pgConnection.prepareStatement("UPDATE item_venda SET fk_item_produto = ?," +
                " preco = ?, quantidade = ?, fk_item_venda = ? WHERE id = ?");

        pStatementItem.setInt(1, this.getProduto(pgConnection));
        pStatementItem.setFloat(2, this.valorUnitario);
        pStatementItem.setFloat(3, this.quantidade);
        pStatementItem.setInt(4, this.vendaId);
        pStatementItem.setInt(5, item_id);

        pStatementItem.execute();

        Statement statementTotal = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet totalValor = statementTotal.executeQuery("SELECT SUM(preco*quantidade) AS total FROM item_venda" +
                " WHERE fk_item_venda = '"+this.vendaId +"';");
        totalValor.first();
        PreparedStatement pStatementVenda = pgConnection.prepareStatement("UPDATE venda" +
                " SET valor_total = ? WHERE id = ?");
        pStatementVenda.setFloat(1, totalValor.getFloat("total"));
        pStatementVenda.setInt(2, this.vendaId);
        pStatementVenda.execute();

        pStatementItem.close();
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

        Statement statementProd = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet resultSetProduto = statementProd.executeQuery("SELECT * FROM produto WHERE id = '"+
                rs.getInt("fk_item_produto")+"'");
        resultSetProduto.first();
        this.produto = transformaEmProduto(resultSetProduto);
        this.quantidade = rs.getFloat("quantidade");
        this.valorUnitario = rs.getFloat("preco");

        PreparedStatement pStatement = pgConnection.prepareStatement("DELETE FROM item_venda WHERE id = ?");
        pStatement.setInt(1, rs.getInt("id"));

        pStatement.execute();
        pgConnection.commit();

        Statement statement = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet totalValor = statement.executeQuery("SELECT SUM(preco*quantidade) AS total FROM item_venda" +
                " WHERE fk_item_venda = '"+this.vendaId +"';");
        totalValor.first();
        PreparedStatement pStatementVenda = pgConnection.prepareStatement("UPDATE venda" +
                " SET valor_total = ? WHERE id = ?");
        pStatementVenda.setFloat(1, totalValor.getFloat("total"));
        pStatementVenda.setInt(2, this.vendaId);
        pStatementVenda.execute();

        pgConnection.commit();
        pStatement.close();
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
        String query = "SELECT * FROM item_venda ";
        if(tipo != 3) {
            query+="WHERE fk_item_venda = '" + entrada + "';";
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
                    +this.itensAssociadosAVenda.getInt("fk_item_produto")+"'");
            DecimalFormat df = new DecimalFormat("0.00");
            df.setRoundingMode(RoundingMode.CEILING);
            produto.first();
            String preco = df.format(produto.getFloat("preco"));
            String antigo_preco = df.format(rs.getFloat("preco"));
            String quantidade = df.format(rs.getFloat("quantidade"));
            System.out.println(String.format("%d) %s - N:%s A:%s qtd:%s", n, produto.getString("nome"),
                    preco, antigo_preco, quantidade));
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
