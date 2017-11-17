package ifrs.edu.br.negocio;

import ifrs.edu.br.OperacoesCrud;
import ifrs.edu.br.autenticacao.Autenticacao;
import ifrs.edu.br.autenticacao.Perfil;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.ResultSet;
import java.util.Scanner;

public class Administrador extends Pessoa implements Autenticacao, OperacoesCrud {

    private String email;
    private boolean ativo;

    public Administrador(String email){
        this.email = email;
        this.ativo = false;
    }

    public Administrador(){}

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isAtivo() {
        return ativo;
    }

    private void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }

    @Override
    public boolean login(String username, String password){
        if(username == this.email && password == "123"){
            setAtivo(true);
            return true;
        }
        else {
            return false;
        }

    }

    @Override
    public Perfil getPerfil(){
        return new Perfil();
    }

    @Override
    protected void entradaUsuario(boolean todasAsEntradas) {
        super.entradaUsuario(todasAsEntradas);
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite o email: ");
        if(!todasAsEntradas){
            String tmp = sc.nextLine();
            if (tmp.length() != 0){
                this.email = tmp;
            }
        }
        else {
            this.email = sc.nextLine();
        }

    }

    @Override
    public void cadastrar(PooledConnection connection) {

    }

    @Override
    public void editar(PooledConnection connection) {

    }

    @Override
    public void deletar(PooledConnection connection) {

    }

    @Override
    public ResultSet procuraRegistro(PooledConnection connection) {
        return null;
    }


    /*
    public void setPerfil(String descricao){
        Perfil perfil = getPerfil();
        perfil.setDescricao(descricao);
    }
    */
}
