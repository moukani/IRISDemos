package com.intersystems.timesheet.control;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.primefaces.event.SelectEvent;

import com.intersystems.timesheet.business.ActivityTypeService;
import com.intersystems.timesheet.model.ActivityType;
import com.intersystems.timesheet.util.FacesUtil;


@Named (value = "activityTypeController")
@ViewScoped
public class ActivityTypeController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private ActivityTypeService activityTypeService;
	
	private ActivityType activityType = new ActivityType();
	
	private List<ActivityType> activityTypes = new ArrayList<ActivityType>();
	
	public String merge() {

		try {
			activityType = activityTypeService.merge(activityType);
			FacesUtil.infoMessage("Successful post", "Activity Type saved successfully");
		} catch (Exception e) {
			activityType = new ActivityType();
			FacesUtil.errorMessage("Unsuccessful post", "Error details: " + e.getMessage());
		}
		

		return null;
	}
	
	public String reset() {

		activityType = new ActivityType();

		return null;
	}
	
	public String delete() {

		try {
			activityTypeService.remove(activityType.getId());
			activityType = new ActivityType();
			getActivityTypeList();
			FacesUtil.infoMessage("Successful deletion", "Activity Type deleted successfully");
		} catch (Exception e) {
			activityType = new ActivityType();
			FacesUtil.errorMessage("Unsuccessful deletion", "Error details: " + e.getMessage());
		}
		
		return null;
	}
	
	public String list() {

		try {
			getActivityTypeList(activityType);
		} catch (Exception e) {
			activityType = new ActivityType();
			FacesUtil.errorMessage("Unsuccessful query", "Error details: " + e.getMessage());
		}

		return null;

	}
	
	private void getActivityTypeList(ActivityType activityType) {
		activityTypes.clear();
		activityTypes.addAll(activityTypeService.getActivityTypeList(activityType));
	}

	
	public List<ActivityType> getActivityTypeList() {
		return activityTypeService.getActivityTypeList();
	}
	
	public void onRowSelect(SelectEvent event) {
		activityType = activityTypeService.load(((ActivityType) event.getObject()).getId());
    }
	
	public ActivityType getActivityType() {
		return activityType;
	}

	public void setActivityType(ActivityType activityType) {
		this.activityType = activityType;
	}

	public List<ActivityType> getActivityTypes() {
		return activityTypes;
	}

	public void setActivityTypes(List<ActivityType> activityTypes) {
		this.activityTypes = activityTypes;
	}
	
}
