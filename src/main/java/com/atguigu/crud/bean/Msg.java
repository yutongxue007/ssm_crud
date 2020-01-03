package com.atguigu.crud.bean;

import java.util.HashMap;
import java.util.Map;

public class Msg {
	
	private int code;
	
	private String msg;
	
	public static Msg success() {
		Msg msg = new Msg();
		msg.setCode(100);
		msg.setMsg("处理成功");
		return msg;
	}
	
	public static Msg fail() {
		Msg msg = new Msg();
		msg.setCode(200);
		msg.setMsg("处理失败");
		return msg;
	}

	//存放返回数据的map
	private Map<String, Object> extend = new HashMap<>();
	
	
	
	//实现链式操作
	public Msg add(String key,Object value) {
		this.getExtend().put(key, value);
		return this;
	}

	public Map<String, Object> getExtend() {
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
	

}
