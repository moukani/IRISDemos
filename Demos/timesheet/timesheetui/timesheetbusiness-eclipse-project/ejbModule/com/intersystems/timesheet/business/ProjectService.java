package com.intersystems.timesheet.business;

import java.io.Serializable;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.intersystems.timesheet.model.Project;

@Stateless
@LocalBean
public class ProjectService implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@PersistenceContext
	private EntityManager em;
	
	public Project merge(Project p) {
		return em.merge(p);
	}
	
	public void remove(Integer id) {
		em.remove(em.find(Project.class, id));;
	}
	
	public Project load(Integer id) {
		return em.find(Project.class, id);
	}
	
	public List<Project> getProjectList() {
		return em.createQuery("SELECT p FROM Project p", Project.class).getResultList();
	}
	
	public List<Project> getProjectList(Project project) {
		String qry = "SELECT p FROM Project p WHERE 1 = 1";
		
		if (project != null && project.getName() != null && !project.getName().isEmpty()) {
			qry = qry + " AND UPPER(p.name) LIKE :name";
		}
		
		if (project != null && project.getDescription() != null && !project.getDescription().isEmpty()) {
			qry = qry + " AND UPPER(p.description) LIKE :description";
		}
		
		TypedQuery<Project> qryProject = em.createQuery(qry, Project.class);
		
		if (project != null && project.getName() != null && !project.getName().isEmpty()) {
			qryProject.setParameter("name", "%" + project.getName().toUpperCase() + "%");
		}
		
		if (project != null && project.getDescription() != null && !project.getDescription().isEmpty()) {
				qryProject.setParameter("description", "%" + project.getDescription().toUpperCase() + "%");
		}
		
		return qryProject.getResultList();
	}


}
