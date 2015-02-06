package com.dEVELdRONE.GForce_Arena;


public class GravityParticle extends Particle{

	private double mass;
	private boolean added;
	public static float gforce = 200;
	private int pointerid;
	
	public GravityParticle(float x, float y, double m, Universe u){
		super(x, y, u);
		mass = m;
		width = 10;
		height = 10;
		added = false;
	}
	
	public GravityParticle(float x, float y, double m, int id, Universe u){
		super(x, y, u);
		mass = m;
		width = 10;
		height = 10;
		added = true;
		pointerid = id;
	}
	
	public void setId(int id){
		pointerid = id;
	}
	
	public int getId(){
		return pointerid;
	}
	
	public void setMass(double m){
		mass = m;
	}
	
	public double getMass(){
		return mass;
	}
	
	public boolean isAdded(){
		return added;
	}
	
	public void setAdded(boolean b){
		added = b;
	}
	
	public static double getGForce(){
		return gforce;
	}
	
	public static void setGForce(float g){
		gforce = g;
	}

	public boolean equals(GravityParticle p) {
		if(getId() == p.getId())
			return true;
		return false;
	}
	
}
