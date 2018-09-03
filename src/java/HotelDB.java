import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class HotelDB {
    private static List<String> lista1 = new ArrayList<String>();
    private static List<String> lista2 = new ArrayList<String>();
    private static Scanner ler;

    public static void main(String[] args) {
        adcConsultas();
        listar();
        //insere();
    }

    protected static void adcConsultas() {
        if (lista1.size() <= 0) {
            lista1.add("Listar funcionarios, com salarios maiores que 1600,"
                    + " por nome, cpf, salario e funcao");
            lista1.add("Listar clientes com reservas por nome, telefone,"
                    + " email e tipo de quarto");
            lista1.add("Listar as informações do cliente mais velho");
            lista1.add("Listando nome e email das pessoas com email do dcomp");
            lista1.add("Listar nome dos dependentes e seus responsaveis");
            lista1.add("Listando clientes em ordem de maior gasto em itens");

            lista2.add("select p.p_nome, p.sobrenome, p.cpf, f.salario, r.funcao from "
                    + "hotel.funcionario f join hotel.pessoa p on(f.pessoa_cpf=p.cpf) "
                    + "natural join hotel.responsavel r where (salario>1600);");
            lista2.add("select p.p_nome, p.sobrenome, t.telefone, e.email, sq.tipo_quarto"
                    + " from hotel.pessoa p join hotel.email e on(pessoa_cpf=cpf) join "
                    + "hotel.telefone t using(pessoa_cpf) join (select c.cod_cliente,"
                    + " pessoa_cpf, r.tipo_quarto from hotel.cliente c join "
                    + "hotel.reserva r using(cod_cliente)) as sq using (pessoa_cpf);");
            lista2.add("select cpf, rg, p_nome, sobrenome, data_nascimento"
                    + " from hotel.pessoa p where p.data_nascimento = "
                    + "(select min(data_nascimento) from hotel.pessoa p1 "
                    + "join hotel.cliente c on(p1.cpf=c.pessoa_cpf));");
            lista2.add("select cpf, rg, p_nome, sobrenome, email"
                    + " from hotel.pessoa p1 join hotel.email e on"
                    + "(p1.cpf=e.pessoa_cpf) where email like '%dcomp.ufs.br';");
            lista2.add("select d.p_nome, d.sobrenome, cod_responsavel, sq.p_nome, sq.sobrenome"
                    + " from hotel.dependentes d join (select p_nome, cod_cliente, sobrenome "
                    + "from hotel.pessoa p join hotel.cliente c on(p.cpf=c.pessoa_cpf)) "
                    + "as sq on(sq.cod_cliente=d.cod_responsavel) order by d.sobrenome;");
            lista2.add("select p_nome, sobrenome, sq.num_registro, cod_cliente, sq.s from hotel.pessoa "
                    + "join hotel.cliente on (cpf=pessoa_cpf) join hotel.registro using(cod_cliente) "
                    + "natural join (select a.num_registro, sum(i.valor*a.quantidade) s from hotel.itens i"
                    + " join hotel.aloca a using(cod_item) group by a.num_registro) as sq order by s desc;");
        }
    }

    protected static void insere() {
        String sql = "INSERT INTO hotel.usuario (nome_usuario,senha)"
                + " VALUES ('"+ler.next()+"','"+ler.next()+"');";
        ConexaoDB con = new ConexaoDB();
        int res = con.executeUpdate(sql);
        if (res >= 1) {
            System.out.println("Inserção realizada!");
        } else {
            System.err.println("Inserção não realizada!");
        }
    }

    protected static void listar() {
        System.out.println("Qual consulta que deseja listar?"
                + " Digite um número de 1 a 10.\n");
        for(int i=0; i<6; i++){
            System.out.println(i+1+"º "+lista1.get(i)+"\n");
        };
        ler = new Scanner(System.in);
        int n = ler.nextInt();
        
        String sql;
        sql = lista2.get(n-1);

        ConexaoDB con = new ConexaoDB();
        try {
            ResultSet consulta = con.executeQuery(sql);
            while (consulta.next()) {
                String nome = consulta.getString(1);
                String nome1 = consulta.getString(2);
                String nome2 = consulta.getString(3);
                String nome3 = consulta.getString(4);
                String nome4 = consulta.getString(5);
                System.out.println(nome + " | " + nome1 + " | " + nome2 + ""
                        + " | " + nome3 + " | " + nome4);
            }
        } catch (SQLException ex) {
            Logger.getLogger(HotelDB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
