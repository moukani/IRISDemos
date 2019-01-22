package com.intersystems.timesheet.control;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.primefaces.event.SelectEvent;

import com.intersystems.timesheet.business.ActivityService;
import com.intersystems.timesheet.model.Activity;
import com.intersystems.timesheet.util.FacesUtil;

@Named(value = "activityController")
@ViewScoped
public class ActivityController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private ActivityService activityService;

	private Activity activity = new Activity();
	
	private List<Activity> activities = new ArrayList<Activity>();

	public String merge() {

		try {
			activity = activityService.merge(activity);
			FacesUtil.infoMessage("Successful post", "Activity saved successfully");
		} catch (Exception e) {
			activity = new Activity();
			FacesUtil.errorMessage("Unsuccessful post", "Error details: " + e.getMessage());
		}

		return null;
	}

	public String reset() {

		activity = new Activity();

		return null;
	}

	public String delete() {

		try {
			activityService.remove(activity.getId());
			activity = new Activity();
			getActivityList();
			FacesUtil.infoMessage("Successful deletion", "Activity deleted successfully");
		} catch (Exception e) {
			activity = new Activity();
			FacesUtil.errorMessage("Unsuccessful deletion", "Error details: " + e.getMessage());
		}

		return null;
	}
	
	public String list() {

		try {
			getActivityList(activity);
		} catch (Exception e) {
			activity = new Activity();
			FacesUtil.errorMessage("Unsuccessful query", "Error details: " + e.getMessage());
		}

		return null;

	}
	
	private void getActivityList(Activity activity) {
		activities.clear();
		activities.addAll(activityService.getActivityList(activity));
	}


	public List<Activity> getActivityList() {
		return activityService.getActivityList();
	}

	public void onRowSelect(SelectEvent event) {
		activity = activityService.load(((Activity) event.getObject()).getId());
	}

	public Activity getActivity() {
		return activity;
	}

	public void setActivity(Activity activity) {
		this.activity = activity;
	}

	public List<Activity> getActivities() {
		return activities;
	}

	public void setActivities(List<Activity> activities) {
		this.activities = activities;
	}

}
