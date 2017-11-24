package ifrs.edu.br.venda;

import com.sun.org.apache.regexp.internal.RE;
import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;
import ifrs.edu.br.negocio.Produto;
import org.postgresql.ds.PGConnectionPoolDataSource;
import org.postgresql.ds.PGPooledConnection;

import javax.sql.PooledConnection;
import java.sql.*;
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
        return connection.createStatement().executeQuery("SELECT * FROM produto " +
                "WHERE nome = '"+this.produto.getNome()+"'").getInt("id");
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

    public void operacoesListaDeVenda(Integer vendaId, PooledConnection connection) throws SQLException{
        try(ResultSet rs = pesquisa(0,String.valueOf(vendaId),connection.getConnection().createStatement(
                ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE))){
            this.itensAssociadosAVenda = rs;
            this.connection = connection.getConnection();
            editar(connection);
        }
    }

    private void entradaUsuario(boolean todasAsEntradas) throws SQLException{
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite a quantidade: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                setProduto();
            }
        }
        else {
            setProduto();
        }
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

    private void setProduto() throws SQLException{
        Produto prod = new Produto();
        ResultSet rs = prod.procuraRegistro(this.connection);
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
    public ResultObjectTuple cadastrar(PooledConnection connection) throws SQLException {
        Connection pgConnection = connection.getConnection();
        Statement statement = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
            ResultSet.CONCUR_UPDATABLE);
        System.out.println("Informe a quantidade do item");
        Scanner sc = new Scanner(System.in);
        entradaUsuario(true);
        statement.execute("INSERT INTO item_venda (fk_item_produto, preco)" +
                "VALUES ('"+this.getProduto(pgConnection)+"','"+this.valorUnitario+"') RETURNING *");
        //escolhe um produto
        //popula o valorUnitario com o valor do produto (nao he referencia)
        //pede quantidade
        //cadastra no banco
        pgConnection.commit();
        ResultSet rs = statement.getResultSet();
        int[] ids = {rs.getInt("id"), this.getProduto(pgConnection)};
        this.ids = ids;
        return new ResultObjectTuple(rs, this);
    }

    private Produto transformaEmProduto(ResultSet rs) throws SQLException{
        Produto produto = new Produto(rs);
        return produto;
    }

    @Override
    public void editar(PooledConnection connection) throws SQLException {
        ResultSet rs = null;
        Connection pgConnection = connection.getConnection();
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
        Statement statement = pgConnection.createStatement();
        ResultSet resultSet = statement.executeQuery("SELECT * FROM item_venda WHERE lista_item_id = '"
                +rs.getInt("lista_item_id")+"'" +
                " AND lista_produto_id = '"+rs.getInt("lista_produto_id")+"';");
        pgConnection.commit();
        this.produto = transformaEmProduto(statement.executeQuery("SELECT * FROM produto WHERE id = '"+
                rs.getInt("lista_produto_id")+"'"));
        this.quantidade = resultSet.getInt("quantidade");
        this.valorUnitario = resultSet.getFloat("preco");

        entradaUsuario(true);

        PreparedStatement pStatementItem = pgConnection.prepareStatement("UPDATE item_venda SET fk_item_produto = ?, preco = ?"+
                " WHERE id = ?");
        PreparedStatement pStatementItemAssoc = pgConnection.prepareStatement("UPDATE lista_venda set lista_item_id = ?," +
                " lista_item_prod = ?, venda_item = ? WHERE id = ?");

        pStatementItem.setInt(1, this.getProduto(pgConnection));
        pStatementItem.setFloat(2, this.valorUnitario);
        pStatementItem.setInt(3, resultSet.getInt("id"));

        pStatementItemAssoc.setInt(1, resultSet.getInt("id"));
        pStatementItemAssoc.setInt(2, this.getProduto(pgConnection));
        pStatementItemAssoc.setInt(3, rs.getInt("venda_item"));
        pStatementItemAssoc.setInt(4, rs.getInt("id"));

        pStatementItem.execute();
        pStatementItemAssoc.execute();

        ResultSet totalValor = statement.executeQuery("SELECT SUM(preco) AS total FROM item_venda CROSS JOIN lista_venda" +
                " WHERE item.venda = lista_venda.lista_item_id AND venda_item = '"+rs.getInt("venda_item")+"';");
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
    public void deletar(PooledConnection connection) throws SQLException{
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
        String query = "SELECT * FROM lista_venda "+
                "WHERE venda_item = '"+entradaTratada[0]+"';";
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
            Statement statement = this.connection.createStatement();
            ResultSet produto = statement.executeQuery("SELECT nome FROM produto WHERE id = '"+this.itensAssociadosAVenda.getInt("venda_item")+"'");
            System.out.println(String.format("%d) %s - %f", n, produto.getString("nome"),
                    rs.getFloat("preco")));
            n+=1;
        }
        if(base < rs.getFetchSize()){
            System.out.println(".) Proximo");
        }
        if(base > 10){
            System.out.println(",) Anterior");
        }
        System.out.println("q) Voltar");

        return n;
    }

}
