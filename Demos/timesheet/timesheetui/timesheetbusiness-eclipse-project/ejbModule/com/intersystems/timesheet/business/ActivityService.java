package com.intersystems.timesheet.business;

import java.io.Serializable;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.intersystems.timesheet.model.Activity;

@Stateless
@LocalBean
public class ActivityService implements Serializable {

	private static final long serialVersionUID = 1L;

	@PersistenceContext
	private EntityManager em;

	public Activity merge(Activity a) {
		return em.merge(a);
	}

	public void remove(Integer id) {
		em.remove(em.find(Activity.class, id));
		;
	}

	public Activity load(Integer id) {
		return em.find(Activity.class, id);
	}

	public List<Activity> getActivityList() {
		return em.createQuery("SELECT a FROM Activity a", Activity.class).getResultList();
	}

	public List<Activity> getActivityList(Integer activityType, Integer project) {
		
		String qry = "SELECT a FROM Activity a WHERE 1 = 1";
		
		if(activityType != null && activityType > 0) {
			qry = qry + " AND a.activityType.id = :activityType";
		}
		
		if(project != null && project > 0) {
			qry = qry + " AND a.project.id = :project";
		}
		
		TypedQuery<Activity> qryActivity = em.createQuery(qry, Activity.class);
		
		if(activityType != null && activityType > 0) {
			qryActivity.setParameter("activityType", activityType);
		}
		
		if(project != null && project > 0) {
			qryActivity.setParameter("project", project);
		}
		
		return qryActivity.getResultList();
		
	}
	

	public List<Activity> getActivityList(Activity activity) {
		String qry = "SELECT a FROM Activity a WHERE 1 = 1";

		if (activity != null && activity.getTitle() != null && !activity.getTitle().isEmpty()) {
			qry = qry + " AND UPPER(a.title) LIKE :title";
		}

		if (activity != null && activity.getProject() != null && activity.getProject().getId() != null && activity.getProject().getId() > 0) {
			qry = qry + " AND a.project.id = :project";
		}

		if (activity != null && activity.getActivityType() != null && activity.getActivityType().getId() != null && activity.getActivityType().getId() > 0) {
			qry = qry + " AND a.activityType.id = :activityType";
		}

		TypedQuery<Activity> qryActivity = em.createQuery(qry, Activity.class);

		if (activity != null && activity.getTitle() != null && !activity.getTitle().isEmpty()) {
			qryActivity.setParameter("title", "%" + activity.getTitle().toUpperCase() + "%");
		}

		if (activity != null && activity.getProject() != null && activity.getProject().getId() != null && activity.getProject().getId() > 0) {
			qryActivity.setParameter("project", activity.getProject().getId());
		}

		if (activity != null && activity.getActivityType() != null && activity.getActivityType().getId() != null && activity.getActivityType().getId() > 0) {
			qryActivity.setParameter("activityType", activity.getActivityType().getId());
		}

		return qryActivity.getResultList();
	}

}
