package ifrs.edu.br.negocio;

import ifrs.edu.br.OperacoesCrud;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.ResultSet;
import java.util.Scanner;

public class Produto implements OperacoesCrud {
    private String nome;
    private String descricao;
    private float preco;

    public Produto(String nome, String descricao, float preco){
        this.nome = nome;
        this.descricao = descricao;
        this.preco = preco;
    }

    public Produto(){}

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public float getPreco() {
        return preco;
    }

    public void setPreco(float preco){
        this.preco = preco;
    }

    @Override
    public boolean equals(Object object){
        Produto teste = (Produto) object;
        return teste.getNome() == this.nome;
    }

    private void entradaUsuario(boolean todasAsEntradas){
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite o nome do produto: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.nome = tmp;
            }
        }
        else {
            this.nome = sc.nextLine();
        }
        System.out.print("Digite a descricao do produto: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.descricao = tmp;
            }
        }
        else {
            this.descricao = sc.nextLine();
        }
        System.out.print("Digite o preco do produto: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.preco = Float.parseFloat(tmp);
            }
        }
        else {
            this.preco = sc.nextFloat();
        }
    }

    @Override
    public void cadastrar(PooledConnection connection) {
        entradaUsuario(true);
    }

    @Override
    public void editar(PooledConnection connection) {
        entradaUsuario(false);
    }

    @Override
    public void deletar(PooledConnection connection) {

    }

    @Override
    public ResultSet procuraRegistro(PooledConnection connection) {
        return null;
    }
}
