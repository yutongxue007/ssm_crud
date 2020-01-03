package com.atguigu.crud.service.impl;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;
import com.atguigu.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeServiceImpl implements EmployeeService {
	
	@Autowired
	EmployeeMapper employeeMapper;

	@Override
	public List<Employee> getAllEmps() {
		//查询所有，条件为null
		List<Employee> list = employeeMapper.selectByExampleWithDept(null);
		return list;
	}

	@Override
	public void saveEmp(Employee employee) {
		//主键自增，使用有选择插入数据
		employeeMapper.insertSelective(employee);
	}

	@Override
	public Employee getEmp(Integer id) {
		Employee employee = employeeMapper.selectByPrimaryKey(id);
		return employee;
	}

	@Override
	public void updateEmp(Employee employee) {
		// TODO Auto-generated method stub
		//根据employee中的主键有选择的更新
		employeeMapper.updateByPrimaryKeySelective(employee);
	}

	@Override
	public void delEmp(Integer empId) {
		// TODO Auto-generated method stub
		employeeMapper.deleteByPrimaryKey(empId);
	}

	@Override
	public void deleteBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}

	@Override
	public boolean checkEmp(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		//返回结果为true时，员工名在数据库可用
		return  count==0;
	}

}
