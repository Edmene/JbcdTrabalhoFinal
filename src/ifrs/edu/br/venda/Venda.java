package ifrs.edu.br.venda;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.negocio.Cliente;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.LinkedList;

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

    public void cancelarVenda(){
        this.status = false;
    }

    public boolean adicionarItem(ItemVenda item){
        try {
            if(!this.listaItens.contains(item)) {
                this.listaItens.add(item);
                float total = 0;
                for (ItemVenda listaIten : listaItens) {
                    total += listaIten.getValorUnitario();
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
                total += listaIten.getValorUnitario();
            }
            this.valorTotal = total;
        }
        catch (Exception e) {
            return false;
        }
        return true;
    }

    @Override
    public String toString(){
        DecimalFormat df = new DecimalFormat("#.##");
        return String.format("valor total: %s | status: %b", df.format(this.valorTotal), this.status);
    }

    @Override
    public void cadastrar(PooledConnection connection) {
        //cliente = pesquisarCliente();
        //data = Date;
        //status = true;
        //listaItens = addListaItems(); //Laco adicionando produtos na lista e banco
        //valorTotal = total dos valores dos produtos
    }

    @Override
    public void editar(PooledConnection connection) {
        //this = pesquisa compra;
        //lista os items
        //pede para remover itens ou alterar quantidade
        //re-calcula o preco final
        //atualiza no banco

    }

    @Override
    public void deletar(PooledConnection connection) {
        //cancelar venda
        //atualiza no banco
    }

    @Override
    public ResultSet procuraRegistro(Connection connection) throws SQLException {
        return null;
    }

}
