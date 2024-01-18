<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
    <script type="text/javascript" src="/assets/js/jquery.js"></script>
    <script type="text/javascript" src="/assets/js/fancyTable.js"></script>
    <script type="text/javascript" src="/assets/js/custom.js"></script>
    <link rel="stylesheet" href="/assets/css/custom.css">
    <title></title>
</head>
<body onload="loadingStart();">
<!-- Main Content -->
<div class="main-content" style="padding: 20px;">
    <div class="row">
        <div class="col-12">
            <div class="card-primary">
                <div class="card-body">
                    <div class="row">
                        <div class="col-12">
                            <div class="">
                                <div class="">
                                    <%--버튼을 누른다--%>
                                        <div class="table-responsive">
                                            <table class="table table-hover table-striped table-md fancy-table">
                                                <thead>
                                                <tr>
                                                    <th>
                                                        <div class="custom-checkbox custom-control">
                                                            <input type="checkbox" data-checkboxes="mygroup" data-checkbox-role="dad" class="custom-control-input" id="checkbox-all">
                                                            <label for="checkbox-all" class="custom-control-label"></label>
                                                        </div>
                                                    </th>
                                                    <th>VMMS No</th>
                                                    <th>VMMS 소속</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="getVmmsCompanyList" items="${getVmmsCompanyList}">
                                                    <%--<tr id="checkbox-mom" onclick="checkboxToggle(
                                                        $('.checkbox-${getVmmsCompanyList.companySeq}').is(':checked'));">--%>
                                                    <tr id="checkbox-mom" onclick="checkboxToggle('checkbox-${getVmmsCompanyList.companySeq}')">
                                                        <td class="p-0 text-center">
                                                            <div class="custom-checkbox custom-control">
                                                                <input type="checkbox" data-checkboxes="mygroup" class="custom-control-input"
                                                                       name="vmmsChecked"
                                                                       id="checkbox-${getVmmsCompanyList.companySeq}">
                                                                <label for="checkbox-${getVmmsCompanyList.companySeq}" class="custom-control-label"></label>
                                                            </div>
                                                        </td>
                                                        <td>${getVmmsCompanyList.companySeq}</td>
                                                        <td>${getVmmsCompanyList.companyName}</td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-6">
                            <button type="button" class="btn btn-primary btn-lg btn-block" onclick="alert($('#vmmsChecked').val())">
                                선택완료
                            </button>
                        </div>
                        <div class="form-group col-6">
                            <button type="button" onclick="self.close();"
                                    class="btn btn-secondary btn-lg btn-block">
                                닫기
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(".fancy-table").fancyTable({
        sortColumn:10, // column number for initial sorting
        sortOrder: 'descending', // 'desc', 'descending', 'asc', 'ascending', -1 (descending) and 1 (ascending)
        sortable: true,
        pagination: true, // default: false
        searchable: true,
        globalSearch: true,
        globalSearchExcludeColumns: [0,20] // exclude column 2 & 5
    });
</script>
</body>
</html>
