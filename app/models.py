from app import db
from datetime import datetime

class TariffType(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    rate = db.Column(db.Float, nullable=False)
    transactions = db.relationship('Transaction', backref='tariff_type', lazy=True)

class Vehicle(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    license_plate = db.Column(db.String(20), nullable=False)
    vehicle_type = db.Column(db.Enum('car', 'motorcycle'), nullable=False)
    transactions = db.relationship('Transaction', back_populates='vehicle', lazy=True)

class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    vehicle_id = db.Column(db.Integer, db.ForeignKey('vehicle.id'), nullable=False)
    entry_time = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    exit_time = db.Column(db.DateTime)
    tariff_id = db.Column(db.Integer, db.ForeignKey('tariff_type.id'))
    total_amount = db.Column(db.Float)
    status = db.Column(db.String(20), default='PENDING')
    vehicle = db.relationship('Vehicle', back_populates='transactions', primaryjoin='Transaction.vehicle_id == Vehicle.id')
