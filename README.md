### Project - Why Is There Difference between Medicare Payment, Subimitted Amounts and Amounts Allowed?

每1-2人一个方向，每人1000字+

暂定进度安排：12月1日前各自有处理结果（report草稿，保存好代码和图），12月4日前合并各自attributes整合模型，12月6日完成论文初稿和ppt，12月7日排练，12月8日或10日presentation，presentation之后更改格式上交

#### Data1 Midwest: Physicians, Detailed  
Region: U.S. Midwest, 12 States  
Provider Types: Cardiology, Cardiac Surgery, Cardiac Electrophysiology  
**选择Procedure 33533 和 Procedure 92928 进行研究**
计算各Procedure中的Payment&Submitted之差作为响应变量  

#### Data2 Dat: Physicians, Aggregated  
选取一些特征作为解释变量  
e.g. 病人性别，年龄……  
e.g. zipcode -> 坐标 -> 距离  

#### Data3 Et: the Referral Network  
选取一些网络图特征作为解释变量  
e.g. 各个层面referral网络的coreness, degree,eigenvector centrality score   
e.g. 设计一些其他的指标  

#### 一些事实
1.不同type的医生有相同的procedure

#### 一些背景知识（来自网络、文献）
1.The decision of whether to refer a patient to another physician is an important determinant of health care quality and spending.1- 5 Patients who are referred to specialists tend to incur greater health care spending compared with those who remain within primary care, even after adjusting for health status. 

2.They are permitted to charge you only 15 percent more than the Medicare-approved amount, and you must pay that extra amount. This is called the "limiting charge" and you do not have to pay more than this amount.

3.Coinsurance is the amount the patient is responsible for paying after the deductible is met,the coinsurance is the difference between the Medicare approved amount and the Medicare payment, which is usually 20% of the approved amount.

