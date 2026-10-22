package edu.dbms.portfolio.service;
public final class Validation { private Validation(){} public static String required(String value,String label){if(value==null||value.trim().isEmpty()) throw new IllegalArgumentException(label+" is required.");if(value.trim().length()>200)throw new IllegalArgumentException(label+" is too long.");return value.trim();} }
