class PiHealth {
  final double cpuTempC;
  final double diskFreeGb;
  final double ramFreeMb;
  final double uptimeHours;
  final String? lastBriefStatus;
  final String? timestamp;

  PiHealth({
    required this.cpuTempC,
    required this.diskFreeGb,
    required this.ramFreeMb,
    required this.uptimeHours,
    this.lastBriefStatus,
    this.timestamp,
  });

  factory PiHealth.fromJson(Map<String, dynamic> json) {
    return PiHealth(
      cpuTempC: (json['cpu_temp_c'] as num?)?.toDouble() ?? 0.0,
      diskFreeGb: (json['disk_free_gb'] as num?)?.toDouble() ?? 0.0,
      ramFreeMb: (json['ram_free_mb'] as num?)?.toDouble() ?? 0.0,
      uptimeHours: (json['uptime_hours'] as num?)?.toDouble() ?? 0.0,
      lastBriefStatus: json['last_brief_status'] as String?,
      timestamp: json['timestamp'] as String?,
    );
  }
}
