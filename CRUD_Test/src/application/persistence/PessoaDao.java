package application.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import application.model.Pessoa;

public class PessoaDao implements IPessoaDao{
	private Connection c;
	
	public PessoaDao() throws ClassNotFoundException, SQLException{
		GenericDao gDao = new GenericDao();
		c = gDao .getConnection();
		}

	@Override
	public void inserePessoa(Pessoa p) throws SQLException {
		String sql = "insert into pessoa values (?,?,?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getCodigo());
		ps.setString(2, p.getNome());
		ps.setInt(3, p.getIdade());
		
		ps.execute();
		ps.close();
	}

	@Override
	public void atualizarPessoa(Pessoa p) throws SQLException {
		String sql = "update pessoa set nome = ?, codigo = ? where codigo = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getCodigo());
		ps.setString(2, p.getNome());
		ps.setInt(3, p.getIdade());
		
		ps.execute();
		ps.close();
	}

	@Override
	public void excluirPessoa(Pessoa p) throws SQLException {
		String sql = "delete pessoa where codigo = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getCodigo());
		ps.setString(2, p.getNome());
		ps.setInt(3, p.getIdade());
		
		ps.execute();
		ps.close();
		
	}

	@Override
	public void buscarPessoa(Pessoa p) throws SQLException {
		String sql = "select codigo, nome, idade from pessoa where codigo = ?";
		
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getCodigo());
		
		int cont = 0;
		ResultSet rs = ps.executeQuery();
		
		if(rs.next()) {
			p.setNome(rs.getString("nome"));
			p.setCodigo(rs.getInt("codigo"));
			cont ++;
			
		}
		if (cont == 0) {
			p = new Pessoa();
			
		}
		rs.close();
		ps.close();
		return;
	}

	@Override
	public List<Pessoa> buscarPessoa() throws SQLException {
		String sql = "select codigo, nome, idade from pessoa";
		
		PreparedStatement ps = c.prepareStatement(sql);
		
		ResultSet rs = ps.executeQuery();
		
		List<Pessoa> listaPessoa = new ArrayList<>();
		
		while (rs.next()) {
			Pessoa p = new Pessoa();
			p.setCodigo(rs.getInt("codigo"));
			p.setNome(rs.getString("nome"));
			p.setIdade(rs.getInt("idade"));
			
			listaPessoa.add(p);
			
		}
		rs.close();
		ps.close();
		
		return listaPessoa;
	}
}
