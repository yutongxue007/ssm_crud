package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;

	/**
	 * 校验员工信息是否存在
	 */
	@ResponseBody
	@RequestMapping("/checkEmp")
	public Msg checkEmp(String empName){
		//在后台进行数据校验
		String reg = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5}$)";
		if(!empName.matches(reg)){
			return Msg.fail().add("msg","用户名必须为字母3-16位/中文2-5位");
		}
		if(employeeService.checkEmp(empName)){
			return Msg.success();
		}else{
			return Msg.fail().add("msg","用户名不可用");
		}
	}
	
	/**
	 * 单个批量都可处理
	 * 根据员工id删除员工信息
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empIds}",method=RequestMethod.DELETE)
	public Msg delEmp(@PathVariable(value="empIds",required=false) String empIds) {
		//判断传来的id值中是否有-(批量删除)
		if(empIds.contains("-")) {
			List<Integer> ids = new ArrayList<>();
			String[] strings = empIds.split("-");
			for (String string : strings) {
				ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(ids);
		}else {
			//单个删除 
			int empId = Integer.parseInt(empIds);
			employeeService.delEmp(empId);
		}
		return Msg.success();
	}
	
	/**
	 * 修改员工信息
	 * @param employee
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg updateEmp(Employee employee) {
		employeeService.updateEmp(employee);
		//方法不需返回数据时返回Msg.success()表成功
		return Msg.success();
	}
	
	/**
	 * 根据id获取员工信息
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("employee", employee);
	}
	
	/**
	 * 保存新增员工信息
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	public Msg saveEmp(Employee employee) {
		employeeService.saveEmp(employee);
		return Msg.success();
	}
	
	@RequestMapping(value="/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		
		//在查询之前使用分页插件
		//1.设置传入的页码和每页显示多少数据
		PageHelper.startPage(pn, 5);
		//2.紧接着查询
		List<Employee> list = employeeService.getAllEmps();
		//3.查询完后使用PageInfo包装查询结果(第二个参数表示连续查询5页)
		PageInfo<Employee> pageInfo = new PageInfo<>(list,5);
		//4.将pageInfo传到页面中
		//model.addAttribute("pageInfo", pageInfo);
		
		//5.跳到view下的list页面
		//return "list";
		return Msg.success().add("pageInfo", pageInfo);
	}
}
