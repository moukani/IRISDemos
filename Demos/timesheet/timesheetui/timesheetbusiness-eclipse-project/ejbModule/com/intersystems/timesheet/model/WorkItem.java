package com.intersystems.timesheet.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "\"WorkItem\"", schema = "\"Timesheet\"")
@NamedQuery(name = "WorkItem.findAll", query = "SELECT w FROM WorkItem w")
public class WorkItem implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "\"Notes\"")
	private String notes;

	@Column(name = "\"WorkEndDate\"")
	private Date workEndDate;

	@Column(name = "\"WorkStartDate\"")
	private Date workStartDate;

	@Column(name = "\"Effort\"")
	private Double effort;

	@Column(name = "\"Cost\"")
	private Double cost;

	@ManyToOne
	@JoinColumn(name = "\"Activity\"")
	private Activity activity = new Activity();

	@ManyToOne
	@JoinColumn(name = "\"Member\"")
	private Member member = new Member();

	public WorkItem() {
	}

	public WorkItem(Member member, Date workStartDate, Date workEndDate, Activity activity, Double effort, Double cost,
			String notes) {
		super();
		this.member = member;
		this.workStartDate = workStartDate;
		this.workEndDate = workEndDate;
		this.activity = activity;
		this.effort = effort;
		this.cost = cost;
		this.notes = notes;
	}

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getNotes() {
		return this.notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public Date getWorkEndDate() {
		return this.workEndDate;
	}

	public void setWorkEndDate(Date workEndDate) {
		this.workEndDate = workEndDate;
	}

	public Date getWorkStartDate() {
		return this.workStartDate;
	}

	public void setWorkStartDate(Date workStartDate) {
		this.workStartDate = workStartDate;
	}

	public Activity getActivity() {
		return this.activity;
	}

	public void setActivity(Activity activity) {
		this.activity = activity;
	}

	public Member getMember() {
		return this.member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Double getEffort() {
		return effort;
	}

	public void setEffort(Double effort) {
		this.effort = effort;
	}

	public Double getCost() {
		return cost;
	}

	public void setCost(Double cost) {
		this.cost = cost;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		WorkItem other = (WorkItem) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return notes;
	}

}