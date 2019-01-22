package com.intersystems.timesheet.business;

import java.io.Serializable;
import java.util.Calendar;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.intersystems.timesheet.model.WorkItem;

@Stateless
@LocalBean
public class TimesheetService implements Serializable {

	private static final long serialVersionUID = 1L;

	@PersistenceContext
	private EntityManager em;

	public WorkItem merge(WorkItem w) {
		return em.merge(w);
	}

	public void remove(Integer id) {
		em.remove(em.find(WorkItem.class, id));
		;
	}

	public WorkItem load(Integer id) {
		return em.find(WorkItem.class, id);
	}

	public List<WorkItem> getWorkItemList() {
		return em.createQuery("SELECT w FROM WorkItem w", WorkItem.class).getResultList();
	}

	public List<WorkItem> getWorkItemList(WorkItem workItem) {
		
		String qry = "SELECT w FROM WorkItem w WHERE 1 = 1";

		if (workItem != null && workItem.getNotes() != null && !workItem.getNotes().isEmpty()) {
			qry = qry + " AND UPPER(w.notes) LIKE :notes";
		}

		if (workItem != null && workItem.getActivity() != null && workItem.getActivity().getProject() != null
				&& workItem.getActivity().getProject().getId() != null
				&& workItem.getActivity().getProject().getId() > 0) {
			qry = qry + " AND w.activity.project.id = :project";
		}

		if (workItem != null && workItem.getActivity() != null && workItem.getActivity().getActivityType() != null
				&& workItem.getActivity().getActivityType().getId() != null
				&& workItem.getActivity().getActivityType().getId() > 0) {
			qry = qry + " AND w.activity.activityType.id = :activityType";
		}

		if (workItem != null && workItem.getActivity() != null && workItem.getActivity().getId() != null
				&& workItem.getActivity().getId() > 0) {
			qry = qry + " AND w.activity.id = :activity";
		}
		
		if (workItem != null && workItem.getWorkStartDate() != null) {
			qry = qry + " AND YEAR(w.workStartDate) = :startDateYear";
			qry = qry + " AND MONTH(w.workStartDate) = :startDateMonth";
			qry = qry + " AND DAY(w.workStartDate) = :startDateDay";
		}

		TypedQuery<WorkItem> qryWorkItem = em.createQuery(qry, WorkItem.class);

		if (workItem != null && workItem.getNotes() != null && !workItem.getNotes().isEmpty()) {
			qryWorkItem.setParameter("notes", "%" + workItem.getNotes().toUpperCase() + "%");
		}

		if (workItem != null && workItem.getActivity() != null && workItem.getActivity().getProject() != null
				&& workItem.getActivity().getProject().getId() != null
				&& workItem.getActivity().getProject().getId() > 0) {
			qryWorkItem.setParameter("project", workItem.getActivity().getProject().getId());
		}

		if (workItem != null && workItem.getActivity() != null && workItem.getActivity().getActivityType() != null
				&& workItem.getActivity().getActivityType().getId() != null
				&& workItem.getActivity().getActivityType().getId() > 0) {
			qryWorkItem.setParameter("activityType", workItem.getActivity().getActivityType().getId());
		}
		
		if (workItem != null && workItem.getActivity() != null && workItem.getActivity().getId() != null
				&& workItem.getActivity().getId() > 0) {
			qryWorkItem.setParameter("activity", workItem.getActivity().getId());
		}
		
		if (workItem != null && workItem.getWorkStartDate() != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(workItem.getWorkStartDate());
			qryWorkItem.setParameter("startDateYear", cal.get(Calendar.YEAR));
			qryWorkItem.setParameter("startDateMonth", cal.get(Calendar.MONTH)+1);
			qryWorkItem.setParameter("startDateDay", cal.get(Calendar.DAY_OF_MONTH));
		}

		return qryWorkItem.getResultList();
	}

}
