package ifrs.edu.br.negocio;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
    public ResultObjectTuple cadastrar(PooledConnection connection) throws SQLException {
        entradaUsuario(true);
        Connection pgConnection = null;
        ResultSet rs = null;
        try {
            pgConnection = connection.getConnection();
            Statement statement = pgConnection.createStatement();
            //Query responsavel pela insersao de um produto
            statement.execute("INSERT INTO produto (nome, descricao, preco)" +
                    " VALUES ('"+this.nome+"','"+
                    this.descricao+"','"+String.valueOf(this.preco)+"') RETURNING *;");
            pgConnection.commit();
            rs = statement.getResultSet();
        }
        catch (Exception e){
            System.err.println(e);
            pgConnection.rollback();
        }
        return new ResultObjectTuple(rs, this);
    }

    @Override
    public void editar(PooledConnection connection) throws SQLException {
        Connection pgConnection = connection.getConnection();
        ResultSet rs = procuraRegistro(pgConnection);
        if(rs == null){
            return;
        }
        rs = selecionaRow(rs, this);
        if(rs == null){
            return;
        }
        this.nome=rs.getString("nome");
        this.descricao=rs.getString("descricao");
        this.preco = rs.getFloat("preco");
        entradaUsuario(false);
        rs.updateString("nome", this.nome);
        rs.updateString("descricao", this.descricao);
        rs.updateFloat("preco", this.preco);
        pgConnection.commit();
        rs.close();
        pgConnection.close();
    }

    @Override
    public Integer construirMenu(ResultSet rs, Integer base) throws SQLException {
        System.out.println("\nResultados de pesquisa");
        base+=1;
        int n=0;
        for (n=base;n<=base+9;n++){
            rs.absolute(n);
            System.out.println(String.format("%d) %s - %f", n, rs.getString("nome"), rs.getFloat("preco")));
            n+=1;
            if(!rs.absolute(n+1)){
                break;
            }
        }
        rs.last();
        int limite = rs.getRow();
        if(base < limite && limite > 9){
            System.out.println(".) Proximo");
        }
        if(base > 10){
            System.out.println(",) Anterior");
        }
        System.out.println("q) Voltar");
        System.out.print("Digite uma opcao: ");

        return n;
    }

    @Override
    public ResultSet procuraRegistro(Connection connection) throws SQLException {
        System.out.println("Digite o nome do produto");
        Scanner sc = new Scanner(System.in);
        String entrada = sc.nextLine();
        Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = null;
        Integer.parseInt(entrada);
        rs = pesquisa(0, entrada, stmt);
        return rs;
    }

    @Override
    public ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException {
        String query = "SELECT * FROM produto WHERE nome LIKE '"+entrada+"';";
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }
}
