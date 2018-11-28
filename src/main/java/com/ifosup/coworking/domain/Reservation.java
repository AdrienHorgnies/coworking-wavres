package com.ifosup.coworking.domain;

import javax.persistence.*;
import java.io.Serializable;
import java.time.Instant;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

public class Reservation implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title")
    private String title;

    @Column(name = "order_date")
    private Instant orderDate;

    @Column(name = "start_date")
    private Instant startDate;

    @Column(name = "end_date")
    private Instant endDate;

    @ManyToOne(optional = false)
    private Space space;

    @ManyToMany
    @JoinTable(name = "reservation_service_type",
        joinColumns = @JoinColumn(name = "reservations_id", referencedColumnName = "id"),
        inverseJoinColumns = @JoinColumn(name = "service_types_id", referencedColumnName = "id"))
    private Set<ServiceType> serviceTypes = new HashSet<>();

    @OneToMany(mappedBy = "reservation")
    private Set<EquipmentOrder> equipmentOrders = new HashSet<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Instant getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Instant orderDate) {
        this.orderDate = orderDate;
    }

    public Instant getStartDate() {
        return startDate;
    }

    public void setStartDate(Instant startDate) {
        this.startDate = startDate;
    }

    public Instant getEndDate() {
        return endDate;
    }

    public void setEndDate(Instant endDate) {
        this.endDate = endDate;
    }

    public Space getSpace() {
        return space;
    }

    public void setSpace(Space space) {
        this.space = space;
    }

    public Set<ServiceType> getServiceTypes() {
        return serviceTypes;
    }

    public void setServiceTypes(Set<ServiceType> serviceTypes) {
        this.serviceTypes = serviceTypes;
    }

    public Set<EquipmentOrder> getEquipmentOrders() {
        return equipmentOrders;
    }

    public void setEquipmentOrders(Set<EquipmentOrder> equipmentOrders) {
        this.equipmentOrders = equipmentOrders;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Reservation reservation = (Reservation) o;
        if (reservation.getId() == null || getId() == null) {
            return false;
        }
        return Objects.equals(getId(), reservation.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(getId());
    }

    @Override
    public String toString() {
        return super.toString();
    }
}