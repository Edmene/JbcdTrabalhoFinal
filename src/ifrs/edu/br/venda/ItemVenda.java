package ifrs.edu.br.venda;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;
import ifrs.edu.br.negocio.Produto;
import org.postgresql.ds.PGConnectionPoolDataSource;
import org.postgresql.ds.PGPooledConnection;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ItemVenda implements OperacoesCrud {
    private Produto produto;
    private float quantidade;
    private float valorUnitario;
    private int idBanco;


    public Produto getProduto() {
        return produto;
    }

    public String getProdutoId() {
        return String.valueOf(idBanco);
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

    String getIdBanco(){
        return String.valueOf(this.idBanco);
    }

    public void setValorUnitario(float valorUnitario) {
        this.valorUnitario = valorUnitario;
    }

    public void operacoesListaDeVenda(Integer vendaId, PooledConnection connection){

    }

    @Override
    public boolean equals(Object object){
        ItemVenda itemVenda = (ItemVenda) object;
        return itemVenda.produto.equals(this.produto);
    }

    @Override
    public ResultObjectTuple cadastrar(PooledConnection connection) {
        //escolhe um produto
        //popula o valorUnitario com o valor do produto (nao he referencia)
        //pede quantidade
        //cadastra no banco
        //cria relacao entre a venda e item na tabela relacao
        return null;
    }


    public ItemVenda retornaCadastro(PooledConnection connection){
        cadastrar(connection);
        return this;
    }

    @Override
    public void editar(PooledConnection connection) {
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
        return null;
    }

    @Override
    public ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException {
        return null;
    }

    @Override
    public Integer construirMenu(ResultSet rs, Integer base) throws SQLException {
        return null;
    }

}
