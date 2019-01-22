package com.intersystems.timesheet.business;

import java.io.Serializable;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.intersystems.timesheet.model.ActivityType;

@Stateless
@LocalBean
public class ActivityTypeService implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@PersistenceContext
	private EntityManager em;
	
	public ActivityType merge(ActivityType at) {
		return em.merge(at);
	}
	
	public void remove(Integer id) {
		em.remove(em.find(ActivityType.class, id));;
	}
	
	public ActivityType load(Integer id) {
		return em.find(ActivityType.class, id);
	}
	
	public List<ActivityType> getActivityTypeList() {
		return em.createQuery("SELECT at FROM ActivityType at", ActivityType.class).getResultList();
	}
	
	public List<ActivityType> getActivityTypeList(ActivityType activityType) {
		String qry = "SELECT a FROM ActivityType a WHERE 1 = 1";
		
		if (activityType != null && activityType.getName() != null && !activityType.getName().isEmpty()) {
			qry = qry + " AND UPPER(a.name) LIKE :name";
		}
		
		if (activityType != null && activityType.getDescription() != null && !activityType.getDescription().isEmpty()) {
			qry = qry + " AND UPPER(a.description) LIKE :description";
		}
		
		TypedQuery<ActivityType> qryActivityType = em.createQuery(qry, ActivityType.class);
		
		if (activityType != null && activityType.getName() != null && !activityType.getName().isEmpty()) {
			qryActivityType.setParameter("name", "%" + activityType.getName().toUpperCase() + "%");
		}
		
		if (activityType != null && activityType.getDescription() != null && !activityType.getDescription().isEmpty()) {
				qryActivityType.setParameter("description", "%" + activityType.getDescription().toUpperCase() + "%");
		}
		
		return qryActivityType.getResultList();
	}


}
