package com.vibetribe.backend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "voucher_usage", schema = "vibetribe")
public class VoucherUsage {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "voucher_usage_id_gen")
    @SequenceGenerator(name = "voucher_usage_id_gen", sequenceName = "voucher_usage_id_seq", schema = "vibetribe", allocationSize = 1)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "voucher_id")
    private Voucher voucher;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private User customer;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "used_at")
    private LocalDateTime usedAt;

}