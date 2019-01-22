package com.intersystems.timesheet.control;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.primefaces.event.SelectEvent;

import com.intersystems.timesheet.business.MemberService;
import com.intersystems.timesheet.model.Member;
import com.intersystems.timesheet.util.FacesUtil;


@Named (value = "memberController")
@ViewScoped
public class MemberController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private MemberService memberService;
	
	private Member member = new Member();
	
	List<Member> members = new ArrayList<Member>();
	
	public String merge() {

		try {
			member = memberService.merge(member);
			FacesUtil.infoMessage("Successful post", "Member saved successfully");
		} catch (Exception e) {
			member = new Member();
			FacesUtil.errorMessage("Unsuccessful post", "Error details: " + e.getMessage());
		}
		

		return null;
	}
	
	public String reset() {

		member = new Member();

		return null;
	}
	
	public String delete() {

		try {
			memberService.remove(member.getId());
			member = new Member();
			getMemberList();
			FacesUtil.infoMessage("Successful deletion", "Member deleted successfully");
		} catch (Exception e) {
			member = new Member();
			FacesUtil.errorMessage("Unsuccessful deletion", "Error details: " + e.getMessage());
		}
		
		return null;
	}
	
	public String list() {
		
		try {
			getMemberList();
		} catch (Exception e) {
			member = new Member();
			FacesUtil.errorMessage("Unsuccessful query", "Error details: " + e.getMessage());
		}
		
		return null;
		
	}

	private void getMemberList() {
		members.clear();
		members.addAll(memberService.getMemberList(member));
	}
	
	public void onRowSelect(SelectEvent event) {
        member = memberService.load(((Member) event.getObject()).getId());
    }
	
	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public List<Member> getMembers() {
		return members;
	}

	public void setMembers(List<Member> members) {
		this.members = members;
	}
	
}
