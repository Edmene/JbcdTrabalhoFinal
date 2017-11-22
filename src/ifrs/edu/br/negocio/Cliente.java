package ifrs.edu.br.negocio;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.ResultObjectTuple;

import javax.sql.PooledConnection;
import java.sql.*;
import java.util.Scanner;

public class Cliente extends Pessoa implements OperacoesCrud {
    private String bandeiraCC;
    private String numeroCC;

    public Cliente(String cpf){
        this.setCpf(cpf);
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
    public ResultObjectTuple cadastrar(PooledConnection connection) throws SQLException {
        entradaUsuario(true);
        Connection pgConnection = null;
        ResultSet rs = null;
        try {
            pgConnection = connection.getConnection();
            Statement statement = pgConnection.createStatement();
            statement.execute("INSERT INTO pessoa (cpf, nome, sobrenome)" +
                    " VALUES ('"+this.getCpf().toString()+"','"+this.getNome()+"','"+this.getSobrenome()+"');");

            //Segunda query responsavel pela insersao de um cliente
            rs = statement.executeQuery("SELECT * FROM pessoa WHERE cpf = '"+this.getCpf()+"';");
            rs.next();
            statement.execute("INSERT INTO cliente (id, bandeiracc, numerocc)"+
                    " VALUES ("+rs.getInt("id")+",'"+this.bandeiraCC+"','"+this.numeroCC+"') RETURNING *;");
            //statement.executeBatch();
            //conn.commit();
            rs = statement.getResultSet();
            pgConnection.commit();
            pgConnection.close();

        }
        catch (Exception e){
            pgConnection.rollback();
            System.err.println(e);
        }
        return new ResultObjectTuple(rs,this);
    }

    @Override
    public void editar(PooledConnection connection) throws SQLException {
        Connection pgConnection = connection.getConnection();
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
        this.numeroCC=rs.getString("numerocc");
        this.bandeiraCC=rs.getString("bandeiracc");
        this.setNome(rs.getString("nome"));
        this.setSobrenome(rs.getString("sobrenome"));
        this.setCpf(rs.getString("cpf"));

        entradaUsuario(false);

        PreparedStatement pStatementPessoa = pgConnection.prepareStatement("UPDATE pessoa SET cpf = ?, nome = ?,"+
        "sobrenome = ? WHERE id = ?");
        PreparedStatement pStatementCliente = pgConnection.prepareStatement("UPDATE cliente set bandeiracc = ?," +
                "numerocc = ? WHERE id = ?");

        pStatementPessoa.setString(1, this.getCpf());
        pStatementPessoa.setString(2, this.getNome());
        pStatementPessoa.setString(3, this.getSobrenome());
        pStatementPessoa.setInt(4, rs.getInt("id"));
        pStatementCliente.setString(1, this.bandeiraCC);
        pStatementCliente.setString(2, this.numeroCC);
        pStatementCliente.setInt(3, rs.getInt("id"));

        pStatementPessoa.execute();
        pStatementCliente.execute();
        /*
        rs.updateString("numerocc", this.numeroCC);
        rs.updateString("bandeiracc", this.bandeiraCC);
        rs.updateString("nome", this.getNome());
        rs.updateString("sobrenome", this.getSobrenome());
        rs.updateString("cpf", String.valueOf(this.getCpf()));
        rs.updateRow();
        Nao funciona em result sets resultantes de JOINs
        */
        pgConnection.commit();
        rs.close();
        pgConnection.close();
    }

    @Override
    public Integer construirMenu(ResultSet rs, Integer base) throws SQLException {
        System.out.println("\nResultados de pesquisa");
        base+=1;
        int n=0;
        System.out.println();
        for (n=base;n<=base+9;n++){
            rs.absolute(n);
            System.out.println(String.format("%d) %s - %s - %s", n, rs.getString("nome"),
                    rs.getString("sobrenome"), rs.getString("cpf")));
            if(!rs.absolute(n+1)){
                break;
            }
        }
        rs.last();
        int limite = rs.getRow();
        if(base < limite && limite > 10){
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
        System.out.println("Digite o nome do cliente ou seu cpf");
        Scanner sc = new Scanner(System.in);
        String entrada = sc.nextLine();
        Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = null;
        try{
            Integer.parseInt(entrada);
            rs = pesquisa(0, entrada, stmt);
        }
        catch (NumberFormatException exception){
            rs = pesquisa(1, entrada, stmt);
        }
        return rs;
    }

    @Override
    public ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException {
        String query = null;
        if(tipo == 0){
            query = "SELECT * FROM cliente INNER JOIN pessoa ON (cliente.id = pessoa.id)"+
                    "WHERE cpf = '"+entrada+"';";
        }
        else {
            query = "SELECT * FROM cliente INNER JOIN pessoa ON (cliente.id = pessoa.id)"+
                    "WHERE nome = '"+entrada+"';";
        }
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

}
