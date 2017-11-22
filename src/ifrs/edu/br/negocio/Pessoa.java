package ifrs.edu.br.negocio;

import java.util.Scanner;

public abstract class Pessoa {
    private String nome;
    private String sobrenome;
    private String cpf;

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSobrenome() {
        return sobrenome;
    }

    public void setSobrenome(String sobrenome) {
        this.sobrenome = sobrenome;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        if(cpf.length() == 9){
            this.cpf = cpf;
        }
        else{
            System.out.println("CPF invalido");
        }
    }

    protected void entradaUsuario(boolean todasAsEntradas) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite o nome: ");
        if (!todasAsEntradas) {
            String tmp = sc.nextLine();
            if (tmp.length() != 0) {
                this.setNome(tmp);
            }
        } else {
            this.setNome(sc.nextLine());
        }
        System.out.print("Digite o sobrenome: ");
        if (!todasAsEntradas) {
            String tmp = sc.nextLine();
            if (tmp.length() != 0) {
                this.setSobrenome(tmp);
            }
        } else {
            this.setSobrenome(sc.nextLine());
        }
        System.out.print("Digite o cpf: ");
        if (!todasAsEntradas) {
            String tmp = sc.nextLine();
            if (tmp.length() != 0) {
                this.setCpf(tmp);
            }
        } else {
            this.setCpf(sc.nextLine());
        }
    }
}
