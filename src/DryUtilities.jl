# -*- coding: utf-8 -*-
module DryUtilities

using DryConstants: C_REF

"Convert [Nm³/h] to [kg/h]."
nm3_h_to_kg_h(q, mw) = C_REF * mw  * q

"Convert [kg/h] to [Nm³/h]."
kg_h_to_nm3_h(ṁ, mw) = ṁ / (C_REF * mw)

end # (module DryUtilities)