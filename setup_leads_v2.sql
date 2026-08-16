-- ============================================================
--  Proyecto 3D — Custom Leads (Pedidos Personalizados)
--  Ejecutar en el SQL Editor de Supabase
--  Crea la tabla + columnas de costos v2
-- ============================================================

-- 1. Crear tabla de pedidos personalizados
CREATE TABLE IF NOT EXISTS public.custom_leads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_name TEXT NOT NULL,
    request_type TEXT DEFAULT 'ofrecido',
    details TEXT,
    material_cost NUMERIC DEFAULT 0,
    hours NUMERIC DEFAULT 0,
    unit_cost NUMERIC DEFAULT 0,
    quantity INTEGER DEFAULT 1,
    status TEXT DEFAULT 'Pendiente',
    deadline_type TEXT DEFAULT 'asap',
    deadline_date DATE,
    -- Costos v2
    electricity_cost NUMERIC DEFAULT 0,
    machine_wear_cost NUMERIC DEFAULT 0,
    failure_reserve NUMERIC DEFAULT 0,
    other_costs NUMERIC DEFAULT 0,
    shipping_cost NUMERIC DEFAULT 0,
    sale_price NUMERIC DEFAULT 0,
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Habilitar RLS
ALTER TABLE public.custom_leads ENABLE ROW LEVEL SECURITY;

-- 3. Solo admins autenticados pueden CRUD
CREATE POLICY "Admin full access custom_leads"
ON public.custom_leads FOR ALL USING (auth.role() = 'authenticated');

-- 4. Vincular print_jobs con leads
ALTER TABLE public.print_jobs ADD COLUMN IF NOT EXISTS lead_id UUID REFERENCES public.custom_leads(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_print_jobs_lead_id ON public.print_jobs (lead_id);

-- ============================================================
-- Done — Custom Leads + v2 costs created.
-- ============================================================
