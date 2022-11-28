package application.controller;

import java.sql.SQLException;
import java.util.List;

import application.model.Pessoa;
import application.persistence.PessoaDao;
import javafx.scene.control.TextField;

public class PessoaController implements IPessoaController {

	private TextField tfCogidoPessoa;
	private TextField tfNomePessoa;
	private TextField tfidade;
	private TextField taListaPessoa;
	
	
	
	
	public PessoaController(TextField tfCogidoPessoa, TextField tfNomePessoa, TextField tfidade) {
		super();
		this.tfCogidoPessoa = tfCogidoPessoa;
		this.tfNomePessoa = tfNomePessoa;
		this.tfidade = tfidade;
	}

	@Override
	public void inserirPessoa(Pessoa p) throws ClassNotFoundException, SQLException {
		PessoaDao pDao = new PessoaDao();
		pDao.inserePessoa(p);
		limpaCampoPessoa();
		buscarPessoa(p);
	}

	@Override
	public void atualizarPessoa(Pessoa p) throws ClassNotFoundException, SQLException {
		PessoaDao pDao = new PessoaDao();
		pDao.inserePessoa(p);
		limpaCampoPessoa();
		buscarPessoa(p);
	}

	@Override
	public void excluirPessoa(Pessoa p) throws ClassNotFoundException, SQLException {
		PessoaDao pDao = new PessoaDao();
		pDao.inserePessoa(p);
		limpaCampoPessoa();
		buscarPessoa(p);
	}

	@Override
	public void buscarPessoa(Pessoa p) throws ClassNotFoundException, SQLException {
		limpaCampoPessoa();
		
		PessoaDao pDao = new PessoaDao();
//		p = pDao.buscarPessoa(p);
		
		tfCogidoPessoa.setText(String.valueOf(p.getCodigo()));
		
		
		
	}

	@Override
	public void buscarPessoas(Pessoa p) throws ClassNotFoundException, SQLException {
		limpaCampoPessoa();
		taListaPessoa.setText("");
		
		PessoaDao pDao = new PessoaDao();
		List<Pessoa> listaPessoas = pDao.buscarPessoa();
	
		StringBuffer buffer = new StringBuffer("Código\t\t\t\tNome\tIdade\n");
		for (Pessoa p1 : listaPessoas) {
			buffer.append(p1.getCodigo()+"\t\t\t\t\t"+p1.getNome()+"\t\t\t\t"+p1.getIdade()+"\n");	
		}
		taListaPessoa.setText(buffer.toString());
		
	}
	private void limpaCampoPessoa() {
		tfCogidoPessoa.setText("");
		tfNomePessoa.setText("");
		tfidade.setText("");
	}

}
