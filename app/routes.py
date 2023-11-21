from flask import render_template, request, redirect, url_for, jsonify
from app import app, db
from app.models import Vehicle, TariffType, Transaction
from datetime import datetime
from sqlalchemy.orm.exc import NoResultFound


@app.route('/')
def index():
    return render_template('index.html')

# Ruta para ingresar un nuevo vehiculo al parqueadero

@app.route('/entry', methods=['GET', 'POST'])
def entry():
    if request.method == 'POST':
        license_plate = request.form.get('license_plate')
        vehicle_type = request.form.get('vehicle_type')
        tariff_type_id = int(request.form.get('tariff_type'))

        existing_vehicle = Vehicle.query.filter_by(license_plate=license_plate).first()

        if existing_vehicle:
            return render_template('entry_form.html', message='El vehiculo con esta Placa ya existe.')

        new_vehicle = Vehicle(license_plate=license_plate, vehicle_type=vehicle_type)
        db.session.add(new_vehicle)
        db.session.commit()

        entry_time = datetime.now()
        new_transaction = Transaction(vehicle_id=new_vehicle.id, entry_time=entry_time, tariff_id=tariff_type_id)
        db.session.add(new_transaction)
        db.session.commit()

        return redirect(url_for('index'))

    tariff_types = TariffType.query.all()
    return render_template('entry_form.html', tariff_types=tariff_types)


# Ruta para liquidar los vehiculos del parqueadero

@app.route('/exit', methods=['GET', 'POST'])
def exit():
    if request.method == 'POST':
        license_plate = request.form.get('license_plate')

        if license_plate:
            vehicles = search_vehicles_by_license_plate(license_plate)
        else:
            vehicles = Vehicle.query.all()

        return render_template('exit_form.html', vehicles=vehicles, selected_license_plate=license_plate)

    vehicles = Vehicle.query.all()
    return render_template('exit_form.html', vehicles=vehicles)

@app.route('/exit/json/<int:vehicle_id>')
def get_vehicle_details_json(vehicle_id):
    try:
        vehicle = Vehicle.query.get_or_404(vehicle_id)
        transaction = vehicle.transactions[-1] if vehicle.transactions else None

        if transaction:
            return jsonify({
                'license_plate': vehicle.license_plate,
                'entry_time': str(transaction.entry_time),
                'exit_time': str(transaction.exit_time),
                'tariff_name': transaction.tariff_type.name,
                'total_amount': transaction.total_amount,
                'status': transaction.status
            })
        else:
            return jsonify({'error': 'No hay transacciones para este vehiculo'}), 404
    except NoResultFound:
        return jsonify({'error': 'Vehiculo no encontrado'}), 404

@app.route('/exit/liquidate/<int:transaction_id>')
def liquidate_transaction(transaction_id):
    try:
        transaction = Transaction.query.get_or_404(transaction_id)

        if transaction.status == 'pending':
            if not transaction.exit_time:
                exit_time = datetime.now()
                transaction.exit_time = exit_time

                parking_duration = exit_time - transaction.entry_time
                total_amount = calculate_total_amount(parking_duration, transaction.tariff_type.rate)
                transaction.total_amount = total_amount
                
                transaction.status = 'paid'

                db.session.commit()

                return redirect(url_for('exit'))

            return jsonify({'error': 'Transacción no válida o ya liquidada'}), 400
        else:
            return jsonify({'error': 'La transacción ya ha sido pagada.'}), 400
    except NoResultFound:
        return jsonify({'error': 'Transacción no encontrada'}), 404

def calculate_total_amount(duration, rate):
    total_hours = duration.total_seconds() / 3600
    return round(total_hours * rate, 2)

def search_vehicles_by_license_plate(license_plate):
    return Vehicle.query.filter(Vehicle.license_plate.ilike(f'%{license_plate}%')).all()


# Ruta para modificar tarifas del parqueadero

@app.route('/modify_tariff', methods=['GET', 'POST'])
def modify_tariff():
    if request.method == 'POST':
        tariff_id = int(request.form.get('tariff_id'))
        new_rate = float(request.form.get('new_rate'))

        tariff_type = TariffType.query.get(tariff_id)
        tariff_type.rate = new_rate

        db.session.commit()

        return redirect(url_for('index'))

    tariff_types = TariffType.query.all()
    return render_template('modify_tariff.html', tariff_types=tariff_types)


# Ruta para crear tarifas en el parqueadero


@app.route('/create_tariff', methods=['GET', 'POST'])
def create_tariff():
    if request.method == 'POST':
        name = request.form.get('name')
        rate = float(request.form.get('rate'))

        new_tariff = TariffType(name=name, rate=rate)
        db.session.add(new_tariff)
        db.session.commit()

        return redirect(url_for('index'))

    return render_template('create_tariff.html')


