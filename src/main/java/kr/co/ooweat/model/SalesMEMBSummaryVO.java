package kr.co.ooweat.model;

import lombok.Data;

@Data
public class SalesMEMBSummaryVO {
    String week;
    long salesCnt;
    long salesAmt;

    long sumTodayAmt;
    long sumThisWeekAmt;
    long sumThisMonthAmt;
}
