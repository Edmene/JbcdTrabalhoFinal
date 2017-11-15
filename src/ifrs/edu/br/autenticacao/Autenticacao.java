package ifrs.edu.br.autenticacao;

public interface Autenticacao {
    boolean login(String username, String password);
    Perfil getPerfil();
}
