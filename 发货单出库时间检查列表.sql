select distinct
       substr(h.dbilldate,1,10) 单据日期,
       substr(b.dsenddate,1,10) 送货日期,
       substr(ic_saleout_b.dbizdate,1,10) 出库日期,
       h.vbillcode 发货单号,
       orgs.name 销售组织,
       customer.code 客户编码,
       customer.name 客户名称,
       material.code 物料编码,
       material.name 物料名称,
       material.materialspec 物料规格,
       defdoc.name 统计分类,
       b.nnum 发货数量,
       h.vdef3 联系人,
       h.vdef5 发票备注,
       h.vdef8 承运公司,
       h.vdef9 司机姓名,
       h.vdef11 收货地址,
       (sum(ic_saleout_b.nnum) over(partition by b.cdeliverybid)) saleoutnnum,
       h.vnote 发货单备注,
       sm_user.user_name 制单人,
       h.creationtime 制单时间
  from so_delivery_b b
  left join so_delivery h
    on b.cdeliveryid = h.cdeliveryid
  left join ic_saleout_b ic_saleout_b
    on ic_saleout_b.csourcebillbid = b.cdeliverybid
  left join bd_customer customer
    on customer.pk_customer = b.cordercustid
  left join bd_material material
    on material.pk_material = b.cmaterialid
  left join org_dept dept
    on dept.pk_dept = b.cdeptid
  left join org_orgs orgs
    on orgs.pk_org = b.csaleorgid
  left join bd_defdoc defdoc
    on defdoc.pk_defdoc = material.def3
  left join sm_user sm_user
    on sm_user.cuserid = h.creator
 where substr(h.dbilldate, 1, 10)>='2016-07-01' and  substr(h.dbilldate, 1, 10)<='2017-07-31' 
   and b.nnum > 0
   and b.dr = 0
   and nvl(ic_saleout_b.dr, 0) = 0
   and orgs.name <> '终端品业务部' and h.vbillcode in ('2016123350','2016122952','2016120919','2017010052','2016120134','2016120137')
 order by orgs.name