package com.vibetribe.backend.infrastructure.usecase.voucher.repository;

import com.vibetribe.backend.entity.VoucherUsage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VoucherUsageRepository extends JpaRepository<VoucherUsage, Long> {
}
