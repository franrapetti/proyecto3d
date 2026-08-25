-- ============================================
-- Calculadora de Costos de Impresión 3D
-- Tabla: print_budgets
-- ============================================

CREATE TABLE IF NOT EXISTS print_budgets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  budget_name TEXT,
  
  -- Inputs del usuario
  printer_cost NUMERIC DEFAULT 0,
  spare_parts_cost NUMERIC DEFAULT 0,
  printer_lifetime_hours INTEGER DEFAULT 5000,
  filament_cost NUMERIC DEFAULT 0,         -- costo por kg
  filament_used NUMERIC DEFAULT 0,          -- gramos utilizados
  electricity_cost_kwh NUMERIC DEFAULT 0,
  printer_watts NUMERIC DEFAULT 0,
  print_hours NUMERIC DEFAULT 0,
  extra_supplies NUMERIC DEFAULT 0,
  packaging NUMERIC DEFAULT 0,
  profit_margin NUMERIC DEFAULT 0,
  
  -- Resultados calculados (se guardan para registro histórico)
  depreciation_cost NUMERIC DEFAULT 0,
  filament_total_cost NUMERIC DEFAULT 0,
  electricity_cost NUMERIC DEFAULT 0,
  total_cost NUMERIC DEFAULT 0,
  price_without_commission NUMERIC DEFAULT 0,
  price_with_commission NUMERIC DEFAULT 0,
  commission_type TEXT DEFAULT '',
  installments TEXT DEFAULT 'none'
);

-- Habilitar RLS
ALTER TABLE print_budgets ENABLE ROW LEVEL SECURITY;

-- Política permisiva para usuarios autenticados
CREATE POLICY "Allow all for authenticated users" ON print_budgets
  FOR ALL
  USING (true)
  WITH CHECK (true);
