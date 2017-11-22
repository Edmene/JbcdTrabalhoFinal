package ifrs.edu.br.negocio;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.*;
import java.util.Scanner;
import java.util.regex.Pattern;

public class Cliente extends Pessoa implements OperacoesCrud {
    private String bandeiraCC;
    private String numeroCC;

    public Cliente(String cpf){
        this.setCpf(cpf.toCharArray());
    }

    public Cliente(){}

    public String getBandeiraCC() {
        return bandeiraCC;
    }

    public void setBandeiraCC(String bandeiraCC) {
        this.bandeiraCC = bandeiraCC;
    }

    public String getNumeroCC() {
        return numeroCC;
    }

    public void setNumeroCC(String numeroCC) {
        this.numeroCC = numeroCC;
    }

    @Override
    protected void entradaUsuario(boolean todasAsEntradas){
        super.entradaUsuario(todasAsEntradas);
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite a bandeira CC: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.bandeiraCC = tmp;
            }
        }
        else {
            this.bandeiraCC = sc.nextLine();
        }
        System.out.print("Digite o numero CC: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.numeroCC = tmp;
            }
        }
        else {
            this.numeroCC = sc.nextLine();
        }
    }

    @Override
    public ResultObjectTuple cadastrar(PooledConnection connection) {
        entradaUsuario(true);
        Connection pgConnection = null;
        ResultSet rs = null;
        try {
            pgConnection = connection.getConnection();
            Statement statement = pgConnection.createStatement();
            //Primeira Query responsavel pela insersao de uma pessoa
            statement.addBatch("INSERT INTO pessoa (cpf, nome, sobrenome)" +
                    " VALUES ("+String.valueOf(this.getCpf())+",'"+
                    this.getNome()+"','"+this.getSobrenome()+"');");

            //Segunda query responsavel pela insersao de um cliente
            statement.addBatch("INSERT INTO cliente (id, bandeiracc, numerocc)"+
            " VALUES ('SELECT id from pessoa WHERE cpf = \'"+this.getCpf()+"\'','"
                    +this.bandeiraCC+"','"+this.numeroCC+"') RETURNING *;");
            statement.executeBatch();
            pgConnection.commit();
            rs = statement.getResultSet();
        }
        catch (Exception e){
            try {
                pgConnection.rollback();
            }
            catch (Exception exception){
                System.err.println(exception);
            }

        }
        return new ResultObjectTuple(rs,this);
    }

    @Override
    public void editar(PooledConnection connection) throws SQLException {
        Connection pgConnection = connection.getConnection();
        ResultSet rs = procuraRegistro(pgConnection);
        rs = selecionaRow(rs, this);
        this.numeroCC=rs.getString("numerocc");
        this.bandeiraCC=rs.getString("bandeiracc");
        this.setNome(rs.getString("nome"));
        this.setSobrenome(rs.getString("sobrenome"));
        this.setCpf(rs.getString("cpf").toCharArray());
        entradaUsuario(false);
        rs.updateString("numerocc", this.numeroCC);
        rs.updateString("bandeiracc", this.bandeiraCC);
        rs.updateString("nome", this.getNome());
        rs.updateString("sobrenome", this.getSobrenome());
        rs.updateString("cpf", String.valueOf(this.getCpf()));
        pgConnection.commit();
        rs.close();
        pgConnection.close();
    }

    @Override
    public Integer construirMenu(ResultSet rs, Integer base) throws SQLException {
        System.out.println("Resultados de pesquisa");
        base+=1;
        int n=0;
        for (n=base;n<=base+9;n++){
            rs.absolute(n);
            System.out.println(String.format("%d) %s - %s", n, rs.getString("nome"), rs.getString("sobrenome")));
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

    @Override
    public ResultSet procuraRegistro(Connection connection) throws SQLException {
        System.out.println("Digite o nome do cliente ou seu cpf");
        Scanner sc = new Scanner(System.in);
        String entrada = sc.nextLine();
        Statement stmt = connection.createStatement();
        ResultSet rs = null;
        try{
            Integer.parseInt(entrada);
            rs = pesquisa(0, entrada, stmt);
        }
        catch (NumberFormatException exception){
            rs = pesquisa(1, entrada, stmt);
        }
        finally {
            stmt.close();
            //connection.close();
        }
        return rs;
    }

    @Override
    public ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException {
        String query = null;
        if(tipo == 0){
            query = "SELECT * FROM cliente INNER JOIN pessoas ON (cliente.id = pessoas.id)"+
                    "WHERE cpf = '"+entrada+"';";
        }
        else {
            query = "SELECT * FROM cliente INNER JOIN pessoas ON (cliente.id = pessoas.id)"+
                    "WHERE nome LIKE = '^"+entrada+"';";
        }
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

}
