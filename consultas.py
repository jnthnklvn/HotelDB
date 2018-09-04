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

    #1 - Listando funcionarios, com salarios maiores que 1600, por nome, cpf, salario e funcao
    def __openFunc(self):
        showinfo("Mariola") 
        
    #2- Listando pessoas por nome, telefone e email    
    def __openpes(self):
        self.__thisTextArea.insert(END,"Quais são todas pessoas com nome, telefone e email?\n\n")
        cur.execute("select p_nome, sobrenome, telefone, email from hotel.pessoa p join hotel.email e on(pessoa_cpf=cpf) join hotel.telefone t using(pessoa_cpf);")
        resulta = "Nome: {}\nSobrenome: {}\nTelefone: {}\nEmail: {}\n\n\n\n"
        for linha in cur.fetchall():
            self.__thisTextArea.insert(END,resulta.format(linha[0],linha[1],linha[2],linha[3]))
 
    #3- Listando as informações do cliente mais velho
    def __openClia(self):
        showinfo("Mariola")

    #4- Listando nome e email das pessoas com email do dcomp
    def __openDes(self):
        showinfo("Mariola")
    
    #5- Listando nome dos dependentes e seus responsaveis
    def __openDepen(self):
        showinfo("Mariola")

    #6- Listando clientes em ordem de maior gasto em itens
    def __openGastoM(self):
        showinfo("Mariola")

    #7- Listando as informações dos clientes maiores de 20 anos
    def __openCli2(self):
        showinfo("Mariola")

    #8- Listando clientes com reservas por nome, telefone, email e tipo de quarto
    def __openClir(self):
        showinfo("Mariola")

    #9- Listando clientes que compraram mais que a média
    def __openCliex(self):
        showinfo("Mariola")

    #10 -Listando o faturamento do hotel
    def __openFat(self):
        showinfo("MAriola")

    #11 - Gera fatura do cliente somando os consumos mais as diárias 
    def __openFatura(self):
        showinfo("MAriola")

    def run(self):
        # Run main application
        self.__root.mainloop()
 
# Run main application
notepad = Janela(width=600,height=400)
notepad.run()