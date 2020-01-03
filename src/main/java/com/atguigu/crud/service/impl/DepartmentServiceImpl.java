package com.atguigu.crud.service.impl;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentServiceImpl implements DepartmentService {
	
	@Autowired
	private DepartmentMapper dm;

	@Override
	public List<Department> getEmps() {
		//查询所有部门，不需要参数
		List<Department> list = dm.selectByExample(null);
		return list;
	}

}
