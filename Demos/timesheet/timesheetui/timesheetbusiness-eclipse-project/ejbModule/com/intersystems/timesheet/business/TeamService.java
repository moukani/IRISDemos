package com.intersystems.timesheet.business;

import java.io.Serializable;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.intersystems.timesheet.model.Team;

@Stateless
@LocalBean
public class TeamService implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@PersistenceContext
	private EntityManager em;
	
	public Team merge(Team t) {
		return em.merge(t);
	}
	
	public void remove(Integer id) {
		em.remove(em.find(Team.class, id));;
	}
	
	public Team load(Integer id) {
		return em.find(Team.class, id);
	}
	
	public List<Team> getTeamList() {
		return em.createQuery("SELECT t FROM Team t", Team.class).getResultList();
	}
	
	public List<Team> getTeamList(Team team) {
		String qry = "SELECT t FROM Team t WHERE 1 = 1";
		
		if (team != null && team.getName() != null && !team.getName().isEmpty()) {
			qry = qry + " AND UPPER(t.name) LIKE :name";
		}
		
		if (team != null && team.getDescription() != null && !team.getDescription().isEmpty()) {
			qry = qry + " AND UPPER(t.description) LIKE :description";
		}
		
		TypedQuery<Team> qryTeam = em.createQuery(qry, Team.class);
		
		if (team != null && team.getName() != null && !team.getName().isEmpty()) {
			qryTeam.setParameter("name", "%" + team.getName().toUpperCase() + "%");
		}
		
		if (team != null && team.getDescription() != null && !team.getDescription().isEmpty()) {
				qryTeam.setParameter("description", "%" + team.getDescription().toUpperCase() + "%");
		}
		
		return qryTeam.getResultList();
	}

}
