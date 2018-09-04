import os
from tkinter import *
from tkinter.messagebox import *
from tkinter.filedialog import *
import linecache
import psycopg2

#Conexão
conn = psycopg2.connect(host="10.27.159.214",database="bd_trabalho", user="aluno", password="aluno")
cur = conn.cursor()

class Janela:

    __convert_cancelada = '|C100|1|0||{2}|02|1|{1}|{0}|||||||||||||||||||||\n'
    __convert_denegada =  '|C100|1|0||{2}|04|1|{1}|{0}|||||||||||||||||||||\n'

    __root = Tk()

    __thisWidth = 300
    __thisHeight = 300

    __thisTextArea = Text(__root)
    __thisMenuBar = Menu(__root)
    __thisFileMenu = Menu(__thisMenuBar, tearoff=0)
    __thisFMenu = Menu(__thisMenuBar, tearoff=0)
    __thisPMenu = Menu(__thisMenuBar, tearoff=0)
    __thisFaMenu = Menu(__thisMenuBar, tearoff=0)

    __thisScrollBarY = Scrollbar(__thisTextArea)
    __thisScrollBarX = Scrollbar(__thisTextArea, orient=HORIZONTAL)   

    __file_sped = None

    def __init__(self, **kwargs):
        try:
            self.__thisWidth = kwargs['width']
        except KeyError:
            pass
 
        try:
            self.__thisHeight = kwargs['height']
        except KeyError:
            pass

        self.__root.title("Retifica SPED")

        screenWidth = self.__root.winfo_screenwidth()
        screenHeight = self.__root.winfo_screenheight()

        left = (screenWidth / 2) - (self.__thisWidth / 2) 
         
        top = (screenHeight / 2) - (self.__thisHeight /2) 
         
        self.__root.geometry('%dx%d+%d+%d' % (self.__thisWidth,
                                              self.__thisHeight,
                                              left, top)) 
 
        self.__root.grid_rowconfigure(0, weight=1)
        self.__root.grid_columnconfigure(0, weight=1)

        self.__thisTextArea.grid(sticky = N + E + S + W)
        self.__thisTextArea.config(wrap=NONE, state=NORMAL)

#Consultas cliente
        self.__thisFileMenu.add_command(label="Quadro Geral",
                                        command=self.__openClir)

        self.__thisFileMenu.add_command(label="Mais antigo",
                                        command=self.__openClia)

        self.__thisFileMenu.add_command(label="Com desconto DCOMP",
                                        command=self.__openDes)  

        self.__thisFileMenu.add_command(label="Por gastos",
                                        command=self.__openGastoM)

        self.__thisFileMenu.add_command(label="Maiores de 20",
                                        command=self.__openCli2)

        self.__thisFileMenu.add_command(label="Gasto maior que média",
                                        command=self.__openCliex)

        self.__thisFileMenu.add_command(label="Dependente/Responsável",
                                        command=self.__openDepen)

#Consultas faturamento
        self.__thisFaMenu.add_command(label="Geral",
                                        command=self.__openCli2)

        self.__thisFaMenu.add_command(label="Fatura",
                                        command=self.__openCli2)
 
#Consultas pessoa
        self.__thisPMenu.add_command(label="Quadro Geral", 
                                    command=self.__openpes)

#Consultas funcionario
        self.__thisFMenu.add_command(label="Salário > R$1600",
                                    command=self.__openFunc)


                                     

        #Chamada das consultas
        self.__thisMenuBar.add_cascade(label="Clientes",
                                       menu=self.__thisFileMenu)

        self.__thisMenuBar.add_cascade(label="Faturamento",
                                        menu=self.__thisFaMenu)
        
        self.__thisMenuBar.add_cascade(label="Funcionários",
                                        menu = self.__thisFMenu)

        self.__thisMenuBar.add_cascade(label="Pessoas",
                                        menu=self.__thisPMenu)

        
        self.__root.config(menu=self.__thisMenuBar)
 
        self.__thisScrollBarY.pack(side=RIGHT,fill=Y)   
        self.__thisScrollBarX.pack(side=BOTTOM, fill=X)                 
         
        # Scrollbar will adjust automatically according to the content        
        self.__thisScrollBarY.config(command=self.__thisTextArea.yview)     
        self.__thisTextArea.config(yscrollcommand=self.__thisScrollBarY.set)
        self.__thisScrollBarX.config(command=self.__thisTextArea.xview)     
        self.__thisTextArea.config(xscrollcommand=self.__thisScrollBarX.set)

    def __quitApplication(self):
        self.__root.destroy()
        # exit()    

    def __showAbout(self):
        showinfo("Retifica SPED","Criado por:")
    def __openFunc(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quais os funcionarios que ganham mais de 1600?\n\n")
        consulta = "Nome: {}\nSobrenome: {}\nCPF: {}\nSalario: R$ {:.2f}\nFunção:{}\n\n\n\n"
    #1 - Listando funcionarios, com salarios maiores que 1600, por nome, cpf, salario e funcao
        cur.execute('''SELECT
                        p.p_nome, p.sobrenome, p.cpf, f.salario, r.funcao FROM
                        hotel.funcionario f JOIN hotel.pessoa p ON(f.pessoa_cpf=p.cpf) NATURAL JOIN
                        hotel.responsavel r WHERE (salario>1600);''')
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,consulta.format(linha[0],linha[1],linha[2],linha[3],linha[4]))
    #2- Listando pessoas por nome, telefone e email    
    def __openpes(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quais são todas pessoas com nome, telefone e email?\n\n")
        cur.execute("select p_nome, sobrenome, telefone, email from hotel.pessoa p join hotel.email e on(pessoa_cpf=cpf) join hotel.telefone t using(pessoa_cpf);")
        resulta = "Nome: {}\nSobrenome: {}\nTelefone: {}\nEmail: {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,resulta.format(linha[0],linha[1],linha[2],linha[3]))
 
    #3- Listando as informações do cliente mais velho
    def __openClia(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quem é nosso cliente mais velho?\n\n")
        cur.execute('''SELECT * FROM hotel.pessoa p WHERE p.data_nascimento = (
                        SELECT min(data_nascimento) FROM hotel.pessoa p1 JOIN hotel.cliente c ON(p1.cpf=c.pessoa_cpf));''')
        resulta = "CPF: {}\nRG: {}\nNome: {}\nSobrenome: {}\nData_Nascimento: {}\nRua: {}\nCEP: {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,resulta.format(linha[0],linha[1],linha[2],linha[3],linha[4],linha[5],linha[6]))

    #4- Listando nome e email das pessoas com email do dcomp
    def __openDes(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quem são as pessoas do DComp e seus emails?\n\n")
        cur.execute('''SELECT p_nome, sobrenome, email FROM hotel.pessoa p1 JOIN hotel.email e ON(p1.cpf=e.pessoa_cpf) ''')
        resulta = "Nome: {}\nSobrenome: {}\nEmail: {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,resulta.format(linha[0],linha[1],linha[2]))
    
    #5- Listando nome dos dependentes e seus responsaveis
    def __openDepen(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quais são os dependentes e seus responsáveis?\n\n")
        cur.execute('''SELECT d.p_nome, d.sobrenome, cod_responsavel, sq.p_nome, sq.sobrenome FROM hotel.dependentes d
                    JOIN (SELECT p_nome, cod_cliente, sobrenome FROM hotel.pessoa p JOIN hotel.cliente c
                ON(p.cpf=c.pessoa_cpf)) as sq ON(sq.cod_cliente=d.cod_responsavel) ORDER BY d.sobrenome;''')
        consulta = "Nome: {}\nSobrenome: {}\nResponsavel: {} {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,consulta.format(linha[0],linha[1],linha[3],linha[4]))

    #6- Listando clientes em ordem de maior gasto em itens
    def __openGastoM(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quem são os maiores gastantes?\n\n")
        cur.execute('''SELECT p_nome, sobrenome, sq.num_registro, sq.s FROM hotel.pessoa JOIN
                        hotel.cliente ON (cpf=pessoa_cpf) JOIN hotel.registro USING(cod_cliente)
                        NATURAL JOIN (SELECT a.num_registro, sum(i.valor*a.quantidade) s FROM 
                        hotel.itens i JOIN hotel.aloca a USING(cod_item) GROUP BY a.num_registro)
                        AS sq ORDER BY s desc;''')
        resulta = "Nome: {}\nSobrenome: {}\nRegistro: {}\nGasto: R$ {:.2f}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,resulta.format(linha[0],linha[1],linha[2],linha[3]))

    #7- Listando as informações dos clientes maiores de 20 anos
    def __openCli2(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quais são os clientes maiores de 20 anos?\n\n")
        cur.execute('''SELECT 
                            p_nome, sobrenome
                        FROM
                        hotel.cliente c
                        JOIN
                            hotel.pessoa
                        ON hotel.pessoa.cpf = c.pessoa_cpf
                    WHERE
                    c.idade > 20
                    ''')
        consulta = "Nome: {}\nSobrenome: {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,consulta.format(linha[0],linha[1]))

    #8- Listando clientes com reservas por nome, telefone, email e tipo de quarto
    def __openClir(self):
        self.__thisTextArea.delete(1.0,END)
        self.__thisTextArea.insert(END,"Quem são os clientes com reserva?\n\n")
        cur.execute('''SELECT p.p_nome, p.sobrenome, t.telefone, e.email, sq.tipo_quarto FROM hotel.pessoa p
                    JOIN hotel.email e ON(pessoa_cpf=cpf) JOIN hotel.telefone tUSING(pessoa_cpf)
                    JOIN (SELECT c.cod_cliente, pessoa_cpf, r.tipo_quarto FROM hotel.cliente c JOIN hotel.reserva r
                    USING(cod_cliente))  AS sq USING (pessoa_cpf);''')
        resulta = "Nome: {}\nSobrenome: {}\nTelefone: {}\nEmail: {}\nQuarto: {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,resulta.format(linha[0],linha[1],linha[2],linha[3],linha[4]))
    #9- Listando clientes que compraram mais que a média
    def __openCliex(self):
        cur.execute('''SELECT
	p_nome, sobrenome, num_registro, sum(i.valor*a.quantidade) valor_items
FROM
    hotel.pessoa 
    JOIN
        hotel.cliente
        ON (cpf=pessoa_cpf)
        JOIN
            hotel.registro
            USING(cod_cliente)
            JOIN 
				hotel.aloca a
				USING(num_registro)
				JOIN
					hotel.itens i
                    USING(cod_item)
GROUP BY
	num_registro,
	pessoa.p_nome,
	sobrenome
HAVING
	sum(i.valor*a.quantidade) > (
					SELECT
						AVG(tb1.valor_items)
					FROM
						(SELECT
							p_nome, sobrenome, num_registro, sum(i.valor*a.quantidade) as valor_items
						FROM
							hotel.pessoa 
							JOIN
								hotel.cliente
								ON (cpf=pessoa_cpf)
								JOIN
									hotel.registro
									USING(cod_cliente)
									JOIN 
										hotel.aloca a
										USING(num_registro)
										JOIN
											hotel.itens i
											USING(cod_item)
						GROUP BY
							num_registro,
							pessoa.p_nome,
sobrenome) as tb1)''')
        self.__thisTextArea.insert(END,cur.fetchall())

    #10 -Listando o faturamento do hotel
    def __openFat(self):
        cur.execute('''SELECT
    (sum(i.valor*a.quantidade) + sum(t.valor)) AS entradas
FROM
    hotel.aloca a
    NATURAL JOIN
        hotel.itens i
        JOIN
          hotel.registro r 
          USING(num_registro)
          JOIN
            hotel.ocupa o 
            USING(num_registro)
            JOIN
                hotel.quarto q
                ON (o.num_quarto=q.numero)
                JOIN
                  hotel.tipo t
ON (q.tipo=t.nome);''')
        self.__thisTextArea.insert(END,cur.fetchall())

    #11 - Gera fatura do cliente somando os consumos mais as diárias 
    def __openFatura(self):
        cur.execute('''SELECT
	p_nome, sobrenome, num_registro, valor_items_comprados+(extract(day from age( hotel.registro.checkout, hotel.registro.checkin))*valor_quarto) as fatura
FROM
    hotel.pessoa 
    JOIN
        hotel.cliente
        ON (cpf=pessoa_cpf)
        JOIN
            hotel.registro
            USING(cod_cliente)
            JOIN
				(SELECT
				 	num_registro,
					SUM(i.valor*a.quantidade) as valor_items_comprados
				FROM
					hotel.aloca a
				 	JOIN
				 		hotel.registro
					USING(num_registro)
					JOIN
						hotel.itens i
                    	USING(cod_item)
				GROUP BY
					num_registro) AS items_comprados
				USING(num_registro)
				JOIN
					(SELECT
					 	num_registro,
						sum(ti.valor) as valor_quarto
					FROM
						hotel.ocupa
						JOIN
					 		hotel.registro
							USING(num_registro)
							JOIN
								hotel.quarto
								ON (hotel.ocupa.num_quarto = hotel.quarto.numero)
								JOIN
									hotel.tipo as ti
									ON ti.nome = hotel.quarto.tipo
					GROUP BY
					num_registro) AS quartos_comprados
USING(num_registro)''')
        self.__thisTextArea.insert(END,cur.fetchall())

    def run(self):
        # Run main application
        self.__root.mainloop()
 
# Run main application
notepad = Janela(width=600,height=400)
notepad.run()
