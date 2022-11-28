package application.persistence;

import java.sql.SQLException;
import java.util.List;

import application.model.Pessoa;

public interface IPessoaDao {

	public void inserePessoa(Pessoa p) throws SQLException;
	public void atualizarPessoa(Pessoa p) throws SQLException;
	public void excluirPessoa(Pessoa p) throws SQLException;
	public void buscarPessoa(Pessoa p) throws SQLException;
	public List<Pessoa> buscarPessoa() throws SQLException;
	
	
}
