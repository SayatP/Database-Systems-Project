import random
from faker import Faker

faker = Faker()

def my_counter(n):
    idx = 1
    while idx <=n:
        yield idx
        idx += 1

def columns_to_fake_sql_data(table, columns, count=100):
    cols = [i.strip() for i in columns.split(',')]
    methods = {col: faker.__getattr__(col) for col in cols}
    data = [tuple(v.__call__() for k,v in methods.items()) for _ in range(count)] 
    with open(f"./data/insert_{table}.sql", "w+") as f:
        f.write(f"insert into {table}({columns})\n")
        f.write("values\n")
        f.writelines([str(i) + ',\n' for i in data[:-1]])
        f.write(str(data[-1]))
        f.write(";")
    return data

def columns_and_func_to_fake_sql_data(table, columns, func, count=100):
    data = [func() for _ in range(count)]
    with open(f"./data/insert_{table}.sql", "w+") as f:
        f.write(f"insert into {table}({columns})\n")
        f.write("values\n")
        f.writelines([str(i) + ',\n' for i in data[:-1]])
        f.write(str(data[-1]))
        f.write(";")
    return data

def columns_and_func_to_fake_sql_data_indexed(table, columns, func, count=100, limit=None):
    data = [func((i+1)%limit+1) for i in range(count)]
    with open(f"./data/insert_{table}.sql", "w+") as f:
        f.write(f"insert into {table}({columns})\n")
        f.write("values\n")
        f.writelines([str(i) + ',\n' for i in data[:-1]])
        f.write(str(data[-1]))
        f.write(";")
    return data


def get_fake_service(NUMBER_OF_ADMINS):
    return (
        faker.text(40),
        faker.text(300),
        f'{random.random() * 300000:.2f}',
        faker.date_time_this_century().strftime('%Y-%m-%d %H:%M:%S'),
        random.randint(1, NUMBER_OF_ADMINS)
    )

def get_fake_application_form(NUMBER_OF_SERVICES):
    return (
        random.randint(1, NUMBER_OF_SERVICES),
        faker.text(10),
        faker.text(300),
        faker.date_time_this_century().strftime('%Y-%m-%d %H:%M:%S'),
    )

def get_fake_application(NUMBER_OF_APPLICATION_FORMS, NUMBER_OF_CLIENTS):
    return (
        random.randint(1, NUMBER_OF_APPLICATION_FORMS),
        random.randint(1, NUMBER_OF_CLIENTS), 
        faker.text(500),
        faker.date_time_this_century().strftime('%Y-%m-%d %H:%M:%S'),
    )

def get_fake_attachment(NUMBER_OF_APPLICATIONS):
    return (
        random.randint(1, NUMBER_OF_APPLICATIONS),
        faker.text(10),
        faker.url(),
    )


def get_fake_review(NUMBER_OF_ADMINS, index):
    return (
        index,
        random.randint(1, NUMBER_OF_ADMINS),
        faker.text(100),
        random.choice(('approved', 'rejected', 'in progress')),
        faker.date_time_this_century().strftime('%Y-%m-%d %H:%M:%S'),
    )


def get_fake_comment(index):
    return (
        index,
        random.randint(1, 100),
        faker.email(),
        faker.date_time_this_century().strftime('%Y-%m-%d %H:%M:%S'),
        faker.text(20)
    )


def get_fake_sponsorship(NUMBER_OF_DONORS, NUMBER_OF_SERVICES):
    return (
        random.randint(1, NUMBER_OF_DONORS),
        random.randint(1, NUMBER_OF_SERVICES),
        f'{random.random() * 10000:.2f}',
        faker.date_time_this_century().strftime('%Y-%m-%d %H:%M:%S'),

    )

