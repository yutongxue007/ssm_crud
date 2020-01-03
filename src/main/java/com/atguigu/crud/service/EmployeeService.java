package com.atguigu.crud.service;

import com.atguigu.crud.bean.Employee;

import java.util.List;

public interface EmployeeService {
	
	List<Employee> getAllEmps();
	
	void saveEmp(Employee employee);

	Employee getEmp(Integer id);

	void updateEmp(Employee employee);

	void delEmp(Integer empId);

	void deleteBatch(List<Integer> ids);

	boolean checkEmp(String empName);
}
