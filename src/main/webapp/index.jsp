<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%
        //request.getContextPath()得到的项目路径以斜线开始，但不以斜线结束
        pageContext.setAttribute("PATH",request.getContextPath());
    %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="${PATH}/static/js/jquery-1.12.4.min.js"></script>
    <link href="${PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        //定义全局变量总记录数和当前页数
        var totalRecord,currentPage;
        //和js自定义函数并排
        //第一个jQuery启动函数(1.查询使用)
        $(function(){
            to_page(1);
        });
        //创建跳转页码函数
        function to_page(pn) {
            $.ajax({
                url:"${PATH}/emps",
                data:"pn="+pn,
                type:"get",
                success:function(result){
                    //1.解析拼接员工信息
                    build_emps_table(result);
                    //2.解析拼接分页条
                    build_page_nav(result);
                    //3.解析并拼接分页信息
                    build_page_info(result);
                }
            })
        }

        function build_emps_table(result) {
            //调用函数之前先清空其中数据
            $("#emps_table tbody").empty();
            //使用jQuery遍历集合方法each
            var emps = result.extend.pageInfo.list;
            $.each(emps,function(i,n){
                //新增多选框
                var checkBoxTd = $("<td><input type='checkbox' class='checkItem' /></td>");
                var empIdTd = $("<td></td>").append(n.empId);
                var empNameTd = $("<td></td>").append(n.empName);
                var genderTd = $("<td></td>").append(n.gender=="M"?"男":"女");
                var emailTd = $("<td></td>").append(n.email);
                var deptNameTd = $("<td></td>").append(n.department.deptName);
                //构建两个按钮
                //两个按钮都新增样式用于操作，注意:因为是多个按钮不能使用id，只能使用class来绑定操作
                var editBtn = $("<button></button").addClass("btn btn-primary btn-sm edit_btn").
                append($("<span></span").addClass("glyphicon glyphicon-pencil")).append("编辑");
                //给每个编辑按钮新增员工id属性
                editBtn.attr("emp-id",n.empId);
                var delBtn = $("<button></button").addClass("btn btn-danger btn-sm del_btn").
                append($("<span></span").addClass("glyphicon glyphicon-trash")).append("删除");
                //给每个删除按钮新增员工id属性
                delBtn.attr("emp-id",n.empId);
                var btnSum = $("<td></td>").append(editBtn).append(" ").append(delBtn);
                //将遍历出的每个员工信息构建成一个tr拼接到tbody(给表格添加id值寻找tbody)中
                //知识点：append和appendTo用法的区别:append是将后面的元素加到前面元素内部，appendTo是将前面的元素加到后面的元素内部
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnSum)
                    .appendTo("#emps_table tbody")
                ;

            });
        }

        function build_page_nav(result) {
            //调用函数之前先清空其中数据
            $("#page_nav").empty();
            $("#page_nav").append("当前"+result.extend.pageInfo.pageNum+"页，总"+result.extend.pageInfo.pages+"页，总"+result.extend.pageInfo.total+"条记录");
            //将总记录数传给全局变量，用于新增员工后跳转到最后一页
            totalRecord = result.extend.pageInfo.total;
            currentPage = result.extend.pageInfo.pageNum;
        }

        function build_page_info(result) {
            //调用函数之前先清空其中数据
            $("#page_info").empty();
            //构建ul
            var ul = $("<ul></ul>").addClass("pagination");
            //构建首末页和前后页
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
            var prevPageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //添加没有上一页时首页和上一页不能点击
            if(result.extend.pageInfo.hasPreviousPage == false){
                firstPageLi.addClass("disabled");
                prevPageLi.addClass("disabled");
            }else{
                //为首页和上一页添加点击事件
                firstPageLi.click(function(){
                    to_page(1);
                });
                prevPageLi.click(function(){
                    //to_page(result.extend.pageInfo.pageNum-1);
                    to_page(result.extend.pageInfo.prePage);
                });
            }
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
            //添加没有下一页时末页和下一页不能点击
            if(result.extend.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else{
                //为末页和下一页添加点击事件
                lastPageLi.click(function(){
                    to_page(result.extend.pageInfo.pages);
                });
                nextPageLi.click(function(){
                    //to_page(result.extend.pageInfo.pageNum+1);
                    to_page(result.extend.pageInfo.nextPage);
                });
            }
            //ul中先添加首页和上一页
            ul.append(firstPageLi).append(prevPageLi);
            //遍历页码
            $.each(result.extend.pageInfo.navigatepageNums,function(i,n){
                var li = $("<li></li>").append($("<a></a>").append(n));
                //给当前页面添加激活标识
                if(result.extend.pageInfo.pageNum==n){
                    li.addClass("active");
                }
                //给当前页码绑定点击事件
                li.click(function(){
                    to_page(n);
                });
                //ul继续添加遍历的页码
                ul.append(li);
            })
            //ul最后添加下一页和末页
            ul.append(nextPageLi).append(lastPageLi);
            //构建nav添加封装好的ul
            var nav = $("<nav></nav>").attr("aria-label","Page navigation").append(ul);
            //最后将nav添加到id为page_info的div中
            nav.appendTo($("#page_info"));
        }

        //第二个jQuery启动函数(2.新增使用)
        $(function(){
            //新增按钮绑定点击事件
            $("#emp_add_modal_btn").click(function(){
                //弹出模态框之前先使用Ajax查询出库中的部门信息
                getDepts("#empAddModal select");
                //新增之前先将form表单清空(表单重置的reset方法在原生js中才有，故需将jQuery对象转为js对象)
                $("#empAddModal form")[0].reset();
                $("#empAddModal form").find("*").removeClass("has-error","has-success");
                $("#empAddModal form").find(".help-block").text("");
                $("#empAddModal").modal({
                    //设置点击模态窗背景不关闭模态窗
                    backdrop:"static"
                });
            });
            //模态框中保存按钮绑定点击事件
            $("#emp_add_btn").click(function(){
                //在发送ajax请求之前先校验模态框中的表单内容
                if(!validate_add_emp()){
                    return false;
                }
                //可测试热部署使用
                //alert($(this).attr("ajax-va"));
                //在提交后台之前获取保存按钮的属性ajax-va的值
                if($(this).attr("ajax-va")=="error"){
                    return false;
                }
                $.ajax({
                    url:"${PATH}/emp",
                    //将模态窗表单内容序列化为字符串(操作对象只有form表单)
                    data:$("#empAddModal form").serialize(),
                    //使用rest风格
                    type:"post",
                    success:function(result){
                        //将模态框关闭
                        $("#empAddModal").modal('hide');
                        //发送ajax请求跳转到最后一页
                        to_page(totalRecord);
                    }
                });
            });

            //模态框中的员工文本框绑定change事件
            $("#empName_add_input").change(function(){
                //input文本框使用val()获取值
                var empName = $(this).val();
                //发送ajax请求去数据库验证
                $.ajax({
                    url:"${PATH}/checkEmp",
                    //data数据有值时以?形式拼接到url后
                    data:{"empName":empName},
                    type:"post",
                    success:function(result){
                        //状态码为100时表示用户名可用(调用显示校验提示信息函数)
                        if(result.code==100){
                            show_validate_msg("#empName_add_input","success","用户名可用");
                            //在前端校验中，此处给保存按钮添加属性较重要
                            $("#emp_add_btn").attr("ajax-va","success");
                        }else{
                            //使用后台给出的提示信息
                            show_validate_msg("#empName_add_input","error",result.extend.msg);
                            $("#emp_add_btn").attr("ajax-va","error");
                        }
                    }
                });
            });

        });

        //查询全部的部门信息
        //新增：添加参数和情况下拉参数
        function getDepts(ele) {
            $(ele).empty();
            $.ajax({
                url:"${PATH}/depts",
                type:"get",
                success:function(result){
                    $.each(result.extend.depts,function(){
                        var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                        optionEle.appendTo(ele);
                    });
                }
            });
        }

        //校验表单
        function validate_add_emp() {
            var empName = $("#empName_add_input").val();
            //用户名支持中文和英文，用|表或者连接
            var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
            if(!regName.test(empName)){
                show_validate_msg("#empName_add_input","error","用户名为字母3-16位/中文2-5位");
                return false;
            }else{
                show_validate_msg("#empName_add_input","success","");
            }
            var empEmail = $("#email_add_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(empEmail)){
                show_validate_msg("#email_add_input","error","邮箱格式不正确");
                return false;
            }else{
                show_validate_msg("#email_add_input","success","");
            }
            return true;
        }

        //显示校验提示信息
        function show_validate_msg(ele,status,msg) {
            //清除当前元素父类之前校验绑定的样式
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if(status=="success"){
                //给当前元素的父类绑定样式
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            }else if(status=="error"){
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        //第三个jQuery启动函数(3.修改使用)
        $(function(){
            //新知识：使用on给document后代绑定事件
            $(document).on("click",".edit_btn",function(){
                //1.查询部门信息
                getDepts("#empEditModal select");
                //2.查询员工信息(获取编辑按钮绑定的员工id属性)
                getEmp($(this).attr("emp-id"));
                //3.把员工id绑定到更新按钮上(因为点击更新要使用当前员工id)
                $("#emp_edit_btn").attr("emp-id",$(this).attr("emp-id"));
                //弹出修改模态框
                $("#empEditModal").modal({
                    //设置点击模态窗背景不关闭模态窗
                    backdrop:"static"
                });
            });

            //更新按钮绑定点击事件
            $("#emp_edit_btn").click(function(){
                //1.先校验修改后的邮箱
                var empEmail = $("#email_edit_input").val();
                var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                if(!regEmail.test(empEmail)){
                    show_validate_msg("#email_edit_input","error","邮箱格式不正确");
                    return false;
                }else{
                    show_validate_msg("#email_edit_input","success","");
                }

                //2.发送ajax请求保存信息
                $.ajax({
                    url:"${PATH}/emp/"+$(this).attr("emp-id"),
                    data:$("#empEditModal form").serialize(),
                    //注意：Tomcat不封装put请求的请求体数据，可在web.xml中配置HttpPutFormContentFilter
                    type:"put",
                    success:function(result){
                        $("#empEditModal").modal("hide");
                        //回到本页面
                        to_page(currentPage);
                    }
                });
            });
        });


        function getEmp(id) {
            $.ajax({
                url:"${PATH}/emp/"+id,
                //ajax中使用data传递数据的方式是?拼接，因为使用restful风格故此处id应在url中拼接
                //data:"id="+id,
                type:"get",
                success:function(result){
                    var empEle = result.extend.employee;
                    $("#empName_edit_input").text(empEle.empName);
                    $("#email_edit_input").val(empEle.email);
                    //单选框和下拉列表使用数组传值
                    $("#empEditModal input[name=gender]").val([empEle.gender]);
                    $("#empEditModal select").val([empEle.dId]);
                }
            });
        }


        //第四个jQuery启动函数(4.删除使用)
        $(function(){
            //给全部的删除按钮绑定点击事件
            $(document).on("click",".del_btn",function(){
                //获取当前员工名(充分利用jQuery的选择器)
                var empName = $(this).parents("tr").find("td:eq(2)").text();
                if(confirm("确认删除【"+empName+"】吗?")){
                    //点击确认按钮时发生ajax请求
                    $.ajax({
                        url:"${PATH}/emp/"+$(this).attr("emp-id"),
                        type:"delete",
                        success:function(result){
                            alert(result.msg);
                            //回到当前页
                            to_page(currentPage);
                        }
                    });
                }
            });

            //给全局多选框设置点击事件
            $("#checkAll").click(function(){
                //新知识：DOM原生的属性使用prop操作，自定义的属性再使用attr操作
                $(".checkItem").prop("checked",$(this).prop("checked"));
            });
            //给每个多选框设置点击事件
            $(document).on("click",".checkItem",function(){
                //判断被选中的多选框和所有的多选框数量是否一样
                var flag = $(".checkItem:checked").length==$(".checkItem").length
                //将结果赋值给全局多选框的checked属性
                $("#checkAll").prop("checked",flag);
            });

            //点击全局删除按钮就批量删除(处理逻辑需要学习)
            $("#emp_del_all_btn").click(function(){
                //存储要删除的员工名
                var empNames = "";
                var empIds = "";
                $.each($(".checkItem:checked"),function(){
                    empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
                    empIds+=$(this).parents("tr").find("td:eq(1)").text()+"-";
                });
                //去除empNames末尾的,
                empNames = empNames.substring(0,empNames.length-1);
                empIds = empIds.substring(0,empIds.length-1);
                //新添加：当未选择要删除的用户时给出提示
                if(empNames.length==0){
                    alert("您还未选择要删除的用户！");
                }else{
                    if(confirm("确认删除【"+empNames+"】吗?")){
                        //执行ajax删除
                        $.ajax({
                            url:"${PATH}/emp/"+empIds,
                            type:"delete",
                            success:function(result){
                                alert(result.msg);
                                to_page(currentPage);
                            }
                        });
                    }
                }
            });

        });

    </script>
</head>
<body>

<!-- 修改Modal -->
<div class="modal fade" id="empEditModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">修改员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <!-- class为form-group表示为一组 -->
                    <!-- 1.员工名 -->
                    <div class="form-group">
                        <label for="empName_edit_input" class="col-sm-2 control-label">员工名</label>
                        <div class="col-sm-10">
                            <!-- 修改为静态控件 -->
                            <p class="form-control-static" id="empName_edit_input"></p>
                        </div>
                    </div>
                    <!-- 2.员工邮箱 -->
                    <div class="form-group">
                        <label for="email_edit_input" class="col-sm-2 control-label">员工邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_edit_input"
                                   placeholder="empEmail@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <!-- 3.员工性别 -->
                    <div class="form-group">
                        <label for="gender_edit_input" class="col-sm-2 control-label">员工性别</label>
                        <div class="col-sm-10">
                            <!-- 使用内联单选按钮 -->
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_edit_input" value="M" checked="checked">男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_edit_input" value="F">女
                            </label>
                        </div>
                    </div>
                    <!-- 4.存在的部门 -->
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门信息</label>
                        <div class="col-sm-4">
                            <!-- 下拉框的name属性为部门id，表示提交部门id -->
                            <select class="form-control" name="dId"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_edit_btn">更新</button>
            </div>
        </div>
    </div>
</div>



<!-- 添加Modal -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <!-- class为form-group表示为一组 -->
                    <!-- 1.员工名 -->
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">员工名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" id="empName_add_input"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <!-- 2.员工邮箱 -->
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">员工邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="empEmail@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <!-- 3.员工性别 -->
                    <div class="form-group">
                        <label for="gender_add_input" class="col-sm-2 control-label">员工性别</label>
                        <div class="col-sm-10">
                            <!-- 使用内联单选按钮 -->
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_add_input" value="M" checked="checked">男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_add_input" value="F">女
                            </label>
                        </div>
                    </div>
                    <!-- 4.存在的部门 -->
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门信息</label>
                        <div class="col-sm-4">
                            <!-- 下拉框的name属性为部门id，表示提交部门id -->
                            <select class="form-control" name="dId"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_add_btn">保存</button>
            </div>
        </div>
    </div>
</div>


<div class="container">
    <!-- 第一行显示标题 -->
    <div class="row">
        <!-- 中型屏幕使用md -->
        <div class="col-md-12">
            <h2>SSM-CRUD</h2>
        </div>
    </div>
    <!-- 第二行显示两个按钮 -->
    <div class="row">
        <!--按钮使用列偏移  col-md-4是本身占4列，col-md-offset-8是偏移8列(总共12列)-->
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_all_btn">删除</button>
        </div>
    </div>
    <!-- 第三行显示表格 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-bordered table-hover" id="emps_table">
                <thead>
                <tr>
                    <th><input type="checkbox" id="checkAll" /></th>
                    <th>员工ID</th>
                    <th>员工姓名</th>
                    <th>员工性别</th>
                    <th>邮箱</th>
                    <th>部门名字</th>
                    <th>操作</th>
                </tr>
                </thead>
                <!-- 为方便ajax拼接，新增tbody标签 -->
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <!-- 第四行显示分页 -->
    <div class="row">
        <!-- 分页信息(占6列) -->
        <div class="col-md-6" id="page_nav"></div>
        <!-- 分页条(占6列) -->
        <div class="col-md-6" id="page_info"></div>
    </div>
</div>
</body>
</html>