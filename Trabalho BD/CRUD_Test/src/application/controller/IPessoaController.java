package application.controller;

import java.sql.SQLException;

import application.model.Pessoa;

public interface IPessoaController {
	
	public void inserirPessoa (Pessoa p) throws ClassNotFoundException, SQLException;
	public void atualizarPessoa (Pessoa p) throws ClassNotFoundException, SQLException;
	public void excluirPessoa (Pessoa p) throws ClassNotFoundException, SQLException;
	public void buscarPessoa (Pessoa p) throws ClassNotFoundException, SQLException;
	public void buscarPessoas (Pessoa p) throws ClassNotFoundException, SQLException;
	
	
}
