class CompanyInsightModel {
  final CompanyInfo? company;
  final CompanyState? currentState;
  final List<String>? keyProblems;
  final List<String>? missingComponents;
  final BusinessImpact? businessImpact;
  final RecommendedSolutions? recommendedSolutions;
  final List<String>? valueForCompany;
  final OutreachSummary? outreachSummary;

  CompanyInsightModel({
    this.company,
    this.currentState,
    this.keyProblems,
    this.missingComponents,
    this.businessImpact,
    this.recommendedSolutions,
    this.valueForCompany,
    this.outreachSummary,
  });

  factory CompanyInsightModel.fromJson(Map<String, dynamic> json) {
    return CompanyInsightModel(
      company: json['company'] != null
          ? CompanyInfo.fromJson(json['company'])
          : null,
      currentState: json['current_state'] != null
          ? CompanyState.fromJson(json['current_state'])
          : null,
      keyProblems: json['key_problems'] != null
          ? List<String>.from(json['key_problems'])
          : [],
      missingComponents: json['missing_components'] != null
          ? List<String>.from(json['missing_components'])
          : [],
      businessImpact: json['business_impact'] != null
          ? BusinessImpact.fromJson(json['business_impact'])
          : null,
      recommendedSolutions: json['recommended_solutions'] != null
          ? RecommendedSolutions.fromJson(json['recommended_solutions'])
          : null,
      valueForCompany: json['value_for_company'] != null
          ? List<String>.from(json['value_for_company'])
          : [],
      outreachSummary: json['outreach_summary'] != null
          ? OutreachSummary.fromJson(json['outreach_summary'])
          : null,
    );
  }
}

class CompanyInfo {
  final String? name;
  final String? type;

  CompanyInfo({this.name, this.type});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      name: json['name'],
      type: json['type'],
    );
  }
}

class CompanyState {
  final String? digitalPresence;
  final String? onlineVisibility;
  final String? customerAcquisition;

  CompanyState({
    this.digitalPresence,
    this.onlineVisibility,
    this.customerAcquisition,
  });

  factory CompanyState.fromJson(Map<String, dynamic> json) {
    return CompanyState(
      digitalPresence: json['digital_presence'],
      onlineVisibility: json['online_visibility'],
      customerAcquisition: json['customer_acquisition'],
    );
  }
}

class BusinessImpact {
  final String? lostLeads;
  final String? revenueLeakage;
  final String? growthPotential;

  BusinessImpact({
    this.lostLeads,
    this.revenueLeakage,
    this.growthPotential,
  });

  factory BusinessImpact.fromJson(Map<String, dynamic> json) {
    return BusinessImpact(
      lostLeads: json['lost_leads'],
      revenueLeakage: json['revenue_leakage'],
      growthPotential: json['growth_potential'],
    );
  }
}

class RecommendedSolutions {
  final String? website;
  final String? seo;
  final String? payments;
  final String? operations;
  final String? marketing;

  RecommendedSolutions({
    this.website,
    this.seo,
    this.payments,
    this.operations,
    this.marketing,
  });

  factory RecommendedSolutions.fromJson(Map<String, dynamic> json) {
    return RecommendedSolutions(
      website: json['website'],
      seo: json['seo'],
      payments: json['payments'],
      operations: json['operations'],
      marketing: json['marketing'],
    );
  }
}

class OutreachSummary {
  final String? goal;
  final String? primaryPitch;
  final String? callToAction;

  OutreachSummary({
    this.goal,
    this.primaryPitch,
    this.callToAction,
  });

  factory OutreachSummary.fromJson(Map<String, dynamic> json) {
    return OutreachSummary(
      goal: json['goal'],
      primaryPitch: json['primary_pitch'],
      callToAction: json['call_to_action'],
    );
  }
}
