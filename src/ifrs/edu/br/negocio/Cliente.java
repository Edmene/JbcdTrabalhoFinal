package ifrs.edu.br.negocio;

import ifrs.edu.br.OperacoesCrud;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

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
    public void cadastrar(PooledConnection connection) {
        entradaUsuario(true);
        Connection pgConnection = null;
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
                    +this.bandeiraCC+"','"+this.numeroCC+"')");
            statement.executeBatch();
            pgConnection.commit();
        }
        catch (Exception e){
            try {
                pgConnection.rollback();
            }
            catch (Exception exception){
                System.err.println(exception);
            }

        }
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
