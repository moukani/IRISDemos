package com.intersystems.timesheet.business;

import java.io.Serializable;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

import com.intersystems.timesheet.model.Member;

@Stateless
@LocalBean
public class MemberService implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@PersistenceContext
	private EntityManager em;
	
	public Member merge(Member m) {
		return em.merge(m);
	}
	
	public void remove(Integer id) {
		em.remove(em.find(Member.class, id));;
	}
	
	public Member load(Integer id) {
		return em.find(Member.class, id);
	}
	
	public List<Member> getMemberList(Member member) {
		String qry = "SELECT m FROM Member m WHERE 1 = 1";
		
		if (member != null && member.getName() != null && !member.getName().isEmpty()) {
			qry = qry + " AND UPPER(m.name) LIKE :name";
		}
		
		if (member != null && member.getEmail() != null && !member.getEmail().isEmpty()) {
			qry = qry + " AND UPPER(m.email) LIKE :email";
		}
		
		TypedQuery<Member> qryMember = em.createQuery(qry, Member.class);
		
		if (member != null && member.getName() != null && !member.getName().isEmpty()) {
			qryMember.setParameter("name", "%" + member.getName().toUpperCase() + "%");
		}
		
		if (member != null && member.getEmail() != null && !member.getEmail().isEmpty()) {
			qryMember.setParameter("email", "%" + member.getEmail().toUpperCase() + "%");
		}
		
		return qryMember.getResultList();
	}
	
	public List<Member> getMemberList() {
		return em.createQuery("SELECT m FROM Member m", Member.class).getResultList();
	}
	
	public Member getMemberByUserAndPassword(String email, String password) {
		
		Member member = new Member();
		Query qry = em.createQuery("SELECT m FROM Member m WHERE m.email = :email AND m.password = :password");
		qry.setParameter("email", email);
		qry.setParameter("password", password);
		try {
			member = (Member) qry.getSingleResult();
		} catch (Exception e) {
			member = new Member();
		}
		
		return member;
	}

}
