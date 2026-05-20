import csv
from pathlib import Path
from datetime import datetime
root = Path(r'c:\Users\HP\Documents\data-analyst-portfolio\project-05-capstone')
for name in ['country_revenue.csv','monthly_revenue.csv','customer_segments.csv']:
    p = root / 'data' / 'exports' / name
    print('---', name, p.exists())
    with p.open('r', encoding='utf-8', errors='replace') as f:
        rows = list(csv.reader(f))
        print('rows', len(rows))
        print('header', rows[0] if rows else None)
        for r in rows[1:6]:
            print(r)
        print()
main = root / 'data' / 'data.csv'
revenue = 0.0
uk_revenue = 0.0
rows = 0
unique_invoice = set()
unique_customers = set()
monthly = {}
with main.open('r', encoding='latin1', errors='replace') as f:
    reader = csv.DictReader(f)
    for row in reader:
        rows += 1
        try:
            qty = float(row['Quantity'])
            price = float(row['UnitPrice'])
        except Exception:
            continue
        rev = qty * price
        revenue += rev
        if row['Country'] == 'United Kingdom':
            uk_revenue += rev
        invdt = None
        for fmt in ('%m/%d/%Y %H:%M', '%d/%m/%Y %H:%M', '%Y-%m-%d %H:%M'):
            try:
                invdt = datetime.strptime(row['InvoiceDate'], fmt)
                break
            except Exception:
                pass
        if invdt is None:
            continue
        ym = invdt.strftime('%Y-%m')
        monthly[ym] = monthly.get(ym, 0) + rev
        unique_invoice.add(row['InvoiceNo'])
        if row['CustomerID']:
            unique_customers.add(row['CustomerID'])
print('rows', rows, 'invoices', len(unique_invoice), 'customers', len(unique_customers))
print('revenue', revenue, 'uk_revenue', uk_revenue, 'uk_pct', uk_revenue / revenue if revenue else None)
for ym in sorted(monthly)[:5]:
    print(ym, monthly[ym])
print('peak', max(monthly.items(), key=lambda x: x[1]))
sorted_months = sorted(monthly.items())
for i, (ym, v) in enumerate(sorted_months):
    if ym.startswith('2011-11'):
        prev = sorted_months[i - 1][1] if i > 0 else None
        print('Nov2011', v, 'prev', prev, 'growth', (v - prev) / prev if prev else None)
seg = {}
with (root / 'data' / 'exports' / 'customer_segments.csv').open('r', encoding='utf-8', errors='replace') as f:
    reader = csv.DictReader(f)
    for row in reader:
        key = row.get('segment') or row.get('Segment') or row.get('SegmentName')
        seg[key] = seg.get(key, 0) + 1
print('segment counts', seg)
