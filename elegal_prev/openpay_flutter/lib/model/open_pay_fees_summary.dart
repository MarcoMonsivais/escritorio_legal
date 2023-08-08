import 'package:json_annotation/json_annotation.dart';

part 'open_pay_fees_summary.g.dart';

@JsonSerializable(nullable: false)
class OpenPayFeesSummary
	{
    OpenPayFeesSummary({
     this.charged,
		 this.charged_tax,
		 this.charged_adjustments,
		 this.charged_adjustments_tax,
		 this.refunded,
		 this.refunded_tax,
		 this.refunded_adjustments,
		 this.refunded_adjustments_tax,
		 this.total
    });
		
		 double charged;
		 double charged_tax;
		 double charged_adjustments;
		 double charged_adjustments_tax;
		 double refunded;
		 double refunded_tax;
		 double refunded_adjustments;
		 double refunded_adjustments_tax;
		 double total;

     factory OpenPayFeesSummary.fromJson(Map<String, dynamic> json) => _$OpenPayFeesSummaryFromJson(json);
        Map<String, dynamic> toJson() => _$OpenPayFeesSummaryToJson(this);

	}